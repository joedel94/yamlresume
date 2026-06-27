<#
.SYNOPSIS
    Private function that checks if a path is relative and throws if not

.PARAMETER Path
    The relative path to the YAML file to process. Defaults to "my-resume.yml".

.PARAMETER ParamName
    No function, should be removed

.EXAMPLE
    Test-RelativePath -Path "my-resume.yml"
#>

function Test-RelativePath {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [string]$ParamName
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        throw "$ParamName must be a relative path."
    }

}