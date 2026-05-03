param(
    [string]$ProfileRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path,
    [string]$Version = '0.1.0'
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$profile = Resolve-Path -LiteralPath $ProfileRoot
$source = Resolve-Path -LiteralPath (Join-Path $profile 'datapacks\new_sky_1010_start')
$mods = Resolve-Path -LiteralPath (Join-Path $profile 'mods')
$jar = Join-Path $mods.Path "new-sky-1010-start-$Version.jar"

if (-not ($source.Path.StartsWith($profile.Path, [System.StringComparison]::OrdinalIgnoreCase))) {
    throw "Source outside profile: $($source.Path)"
}

if (-not ($mods.Path.StartsWith($profile.Path, [System.StringComparison]::OrdinalIgnoreCase))) {
    throw "Mods outside profile: $($mods.Path)"
}

if (Test-Path -LiteralPath $jar) {
    $resolvedJar = Resolve-Path -LiteralPath $jar
    if (-not ($resolvedJar.Path.StartsWith($mods.Path, [System.StringComparison]::OrdinalIgnoreCase))) {
        throw "Jar outside mods: $($resolvedJar.Path)"
    }
    Remove-Item -LiteralPath $resolvedJar.Path -Force
}

$base = $source.Path.TrimEnd('\') + '\'
$zip = [System.IO.Compression.ZipFile]::Open($jar, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Get-ChildItem -LiteralPath $source.Path -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($base.Length).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zip,
            $_.FullName,
            $relative,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }
}
finally {
    $zip.Dispose()
}

Get-Item -LiteralPath $jar | Select-Object FullName,Length
