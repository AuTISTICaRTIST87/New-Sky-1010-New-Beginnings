param(
    [string]$MinecraftVersion = "1.21.1",
    [string]$Loader = "fabric",
    [string]$InputFile = "notes/modrinth-download-list.txt",
    [string]$ModsDir = "mods",
    [switch]$DryRun,
    [switch]$NoDependencies
)

$ErrorActionPreference = "Stop"
$apiBase = "https://api.modrinth.com/v2"
$headers = @{
    "User-Agent" = "New Sky 1010 modpack downloader (github.com/AuTISTICaRTIST87/New-Sky-1010-New-Beginnings)"
}
$downloadedProjects = @{}
$missing = New-Object System.Collections.Generic.List[string]

function Invoke-ModrinthJson {
    param([string]$Uri)
    $attempt = 0
    while ($true) {
        try {
            Start-Sleep -Milliseconds 350
            return Invoke-RestMethod -Uri $Uri -Headers $headers
        } catch {
            $attempt++
            $response = $_.Exception.Response
            $statusCode = if ($response) { [int]$response.StatusCode } else { 0 }
            if ($statusCode -eq 429 -and $attempt -lt 6) {
                $retryAfter = 2
                if ($response.Headers["Retry-After"]) {
                    [int]::TryParse($response.Headers["Retry-After"], [ref]$retryAfter) | Out-Null
                }
                Write-Warning "Modrinth rate limit hit. Waiting $retryAfter second(s), then retrying..."
                Start-Sleep -Seconds $retryAfter
                continue
            }
            throw
        }
    }
}

function ConvertTo-UrlJsonArray {
    param([string[]]$Values)
    $escaped = $Values | ForEach-Object {
        '"' + (($_ -replace '\\', '\\') -replace '"', '\"') + '"'
    }
    [uri]::EscapeDataString("[$($escaped -join ',')]")
}

function ConvertTo-UrlJsonNestedArray {
    param([string[][]]$Groups)
    $parts = foreach ($group in $Groups) {
        $escaped = $group | ForEach-Object {
            '"' + (($_ -replace '\\', '\\') -replace '"', '\"') + '"'
        }
        "[$($escaped -join ',')]"
    }
    [uri]::EscapeDataString("[$($parts -join ',')]")
}

function Get-PrimaryFile {
    param($Version)

    $primary = $Version.files | Where-Object { $_.primary -eq $true } | Select-Object -First 1
    if ($primary) { return $primary }

    return $Version.files | Where-Object { $_.filename -like "*.jar" } | Select-Object -First 1
}

function Resolve-Project {
    param([string]$NameOrSlug)

    $clean = $NameOrSlug.Trim()
    if ($clean -match "^https://modrinth\.com/mod/([^/\s]+)") {
        $clean = $Matches[1]
    }

    try {
        return Invoke-ModrinthJson "$apiBase/project/$clean"
    } catch {
        $facets = ConvertTo-UrlJsonNestedArray @(
            @("project_type:mod"),
            @("categories:$Loader"),
            @("versions:$MinecraftVersion")
        )
        $query = [uri]::EscapeDataString($clean)
        $search = Invoke-ModrinthJson "$apiBase/search?query=$query&limit=5&facets=$facets"
        if (-not $search.hits -or $search.hits.Count -eq 0) {
            throw "No Modrinth project found for '$NameOrSlug' on $Loader $MinecraftVersion."
        }

        $best = $search.hits |
            Sort-Object @{ Expression = { if ($_.slug -eq $clean -or $_.title -eq $clean) { 0 } else { 1 } } }, downloads -Descending |
            Select-Object -First 1

        return Invoke-ModrinthJson "$apiBase/project/$($best.project_id)"
    }
}

function Get-CompatibleVersion {
    param([string]$ProjectId)

    $loaders = ConvertTo-UrlJsonArray @($Loader)
    $versions = ConvertTo-UrlJsonArray @($MinecraftVersion)
    $url = "$apiBase/project/$ProjectId/version?loaders=$loaders&game_versions=$versions"
    $versionsResult = @(Invoke-ModrinthJson $url)
    if ($versionsResult.Count -eq 0) {
        return $null
    }

    return $versionsResult |
        Where-Object { Get-PrimaryFile $_ } |
        Sort-Object date_published -Descending |
        Select-Object -First 1
}

function Download-Project {
    param(
        [string]$NameOrSlug,
        [string]$Reason = "requested"
    )

    $project = Resolve-Project $NameOrSlug
    if ($downloadedProjects.ContainsKey($project.id)) {
        return
    }
    $downloadedProjects[$project.id] = $true

    $version = Get-CompatibleVersion $project.id
    if (-not $version) {
        $missing.Add("$($project.title) [$($project.slug)] - no $Loader build for Minecraft $MinecraftVersion")
        Write-Warning "No compatible version: $($project.title) ($($project.slug))"
        return
    }

    $file = Get-PrimaryFile $version
    if (-not $file) {
        $missing.Add("$($project.title) [$($project.slug)] - compatible version has no jar file")
        Write-Warning "No jar file: $($project.title) ($($project.slug))"
        return
    }

    if (-not (Test-Path -LiteralPath $ModsDir)) {
        New-Item -ItemType Directory -Path $ModsDir | Out-Null
    }

    $target = Join-Path $ModsDir $file.filename
    if (Test-Path -LiteralPath $target) {
        Write-Host "Already present: $($file.filename)"
    } elseif ($DryRun) {
        Write-Host "Would download: $($project.title) -> $($file.filename) ($Reason)"
    } else {
        Write-Host "Downloading: $($project.title) -> $($file.filename) ($Reason)"
        Invoke-WebRequest -Uri $file.url -OutFile $target -Headers $headers
    }

    if (-not $NoDependencies) {
        foreach ($dep in @($version.dependencies)) {
            if ($dep.dependency_type -eq "required" -and $dep.project_id) {
                Download-Project $dep.project_id "dependency of $($project.slug)"
            }
        }
    }
}

if (-not (Test-Path -LiteralPath $InputFile)) {
    throw "Input file not found: $InputFile"
}

$entries = Get-Content -LiteralPath $InputFile |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith("#") }

foreach ($entry in $entries) {
    try {
        Download-Project $entry
    } catch {
        $missing.Add("$entry - $($_.Exception.Message)")
        Write-Warning $_.Exception.Message
    }
}

Write-Host ""
Write-Host "Done. Requested entries: $($entries.Count). Unique projects handled: $($downloadedProjects.Count)."
if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing or skipped:"
    $missing | ForEach-Object { Write-Host "- $_" }
    exit 2
}
