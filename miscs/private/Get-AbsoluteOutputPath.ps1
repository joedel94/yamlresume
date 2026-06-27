<#
.SYNOPSIS
    Private helper that resolves and normalizes output paths

.DESCRIPTION
    This function resolves a relative path to an absolute path and normalizes 
    it to use forward slashes for reference by the Docker container. 
    Additionally the path will be checked to confirm it exists and if it does 
    not it will be created.

.PARAMETER OutputPath
    The relative path to the YAML file to process. Defaults to "my-resume.yml".

.EXAMPLE
    Get-AbsoluteOutputPath -Path 'C:\Users\USERNAME\MyResumes\my-resume.yml'
#>

function Get-AbsoluteOutputPath {

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path -Path $Path) {
        try {
            Write-Verbose "Path '$Path' not found. Creating directory."
            $AbsoluteOutputPath = (New-Item -Path $Path -ItemType Directory).FullName
        }
        catch {
            throw "Issue encountered when attempting to make new directory $Path, full error: $($_.ErrorDetails.Message)"
        }
    }
    else {
        $AbsoluteOutputPath = (Resolve-Path -LiteralPath $Path).Path
    }

    #Normalize the path to use forward slashes
    return $AbsoluteOutputPath -replace '\\', '/'
}