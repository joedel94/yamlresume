# Private helper: resolves and normalizes output path
function Get-AbsoluteOutputPath {
    param([Parameter(ValueFromPipeline)][string]$OutputPath)
    $absoluteOutputPath = (Resolve-Path -Path $OutputPath -ErrorAction SilentlyContinue).Path
    if (-not $absoluteOutputPath) {
        $absoluteOutputPath = (New-Item -Path $OutputPath -ItemType Directory -Force).FullName
    }
    return $absoluteOutputPath -replace '\\', '/'
}