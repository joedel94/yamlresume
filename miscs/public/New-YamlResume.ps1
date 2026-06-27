<#
.SYNOPSIS
    Generates a new YAML résumé file using YAML Resume CLI via Docker.

.PARAMETER YamlFile
    The relative path for the new YAML file to create. Defaults to "my-resume.yml".

.EXAMPLE
    New-YamlResume -YamlFile custom.yml
#>

function New-YamlResume {

    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$YamlFile = "my-resume.yml"
    )

    try {
        Test-RelativePath $YamlFile 'YamlFile' 
    }
    catch {
        Write-Error $_
        return
    }

    $absoluteOutputPath = Get-AbsoluteOutputPath (Get-Location).Path

    Write-Verbose "About to execute: docker run --rm -v `"$($absoluteOutputPath):/home/yamlresume`" yamlresume/yamlresume new $YamlFile"
    docker run --rm -v "$($absoluteOutputPath):/home/yamlresume" yamlresume/yamlresume new $YamlFile

}