<#
.SYNOPSIS
    Builds a résumé from a specified YAML file using YAML Resume CLI via Docker.

.PARAMETER YamlFile
    The relative path to the YAML file to process. Defaults to "my-resume.yml".

.PARAMETER OutputPath
    The output directory where the built résumé will be saved. Defaults to "./Latest".

.EXAMPLE
    Build-YamlResume -YamlFile "custom.yml" -OutputPath "./2025-11-01"
#>

function Build-YamlResume {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({
                -not ([System.IO.Path]::IsPathRooted($_)) 
            },
            ErrorMessage = "{0} must be a relative path."
        )]
        [ValidateScript({
                (Test-Path $YamlFile -PathType Leaf) 
            },
            ErrorMessage = "YamlFile {0} not found, check your path."
        )]
        [string]$YamlFile = "my-resume.yml",

        [Parameter(Mandatory = $false)]
        [ValidateScript({
                -not ([System.IO.Path]::IsPathRooted($_)) 
            },
            ErrorMessage = "{0} must be a relative path."
        )]
        [string]$OutputPath = "./Latest"
    )

    $AbsoluteOutputPath = Get-AbsoluteOutputPath -Path $OutputPath

    if (Test-Path $AbsoluteOutputPath) {
        Get-ChildItem -Path $AbsoluteOutputPath | Remove-Item -Recurse -Force
    }

    Copy-Item -Path $YamlFile -Destination $AbsoluteOutputPath -Force
    $ContainerFile = Split-Path -Leaf $YamlFile
    Write-Verbose "About to execute: docker run --rm -v `"$($AbsoluteOutputPath):/home/yamlresume`" yamlresume/yamlresume build $containerFile"
    docker run --rm -v "$($AbsoluteOutputPath):/home/yamlresume" yamlresume/yamlresume build $containerFile

}