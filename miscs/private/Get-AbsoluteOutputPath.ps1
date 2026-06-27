<#
.SYNOPSIS
    Private helper that resolves and normalizes output paths

.PARAMETER OutputPath
    The relative path to the YAML file to process. Defaults to "my-resume.yml".

.EXAMPLE
    Get-AbsoluteOutputPath -Path 'C:\Users\USERNAME\MyResumes\my-resume.yml'
#>

function Get-AbsoluteOutputPath {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [string]$OutputPath
    )

    $AbsoluteOutputPath = (Resolve-Path -Path $OutputPath -ErrorAction SilentlyContinue).Path

    if (-not $AbsoluteOutputPath) {
        $AbsoluteOutputPath = (New-Item -Path $OutputPath -ItemType Directory -Force).FullName
    }

    return $AbsoluteOutputPath -replace '\\', '/'
}