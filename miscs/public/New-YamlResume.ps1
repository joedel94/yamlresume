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
        [Parameter(Position = 0, Mandatory = $false)]
        [ValidateScript({
                -not ([System.IO.Path]::IsPathRooted($_)) 
            },
            ErrorMessage = "{0} must be a relative path."
        )]
        [string]$YamlFile = "my-resume.yml"
    )

    try {
        Test-RelativePath $YamlFile 'YamlFile' 
    }
    catch {
        Write-Error $_
        return
    }

    #Normalizes output path to work with docker container and ensures we are working with only one literal path
    $OutputPath = Get-AbsoluteOutputPath -Path $PWD.Path

    Write-Verbose "About to execute: docker run --rm -v `"$($OutputPath):/home/yamlresume`" yamlresume/yamlresume new $YamlFile"
    docker run --rm -v "$($OutputPath):/home/yamlresume" yamlresume/yamlresume new $YamlFile

}