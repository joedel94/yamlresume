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

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({
                -not ([System.IO.Path]::IsPathRooted($_)) 
            },
            ErrorMessage = "{0} must be a relative path."
        )]
        [ValidateScript({
                (Test-Path -Path $_)
            },
            ErrorMessage = "YamlFile {0} not found, check your path."
        )]
        [string]$YamlFile = "my-resume.yml",

        [Parameter(Mandatory = $false)]
        [string]$OutputPath = "./Latest"
    )
    
    $AbsoluteOutputPath = Get-AbsoluteOutputPath -Path $OutputPath

    #Moves target resume .yml file to the output path so it can be referenced by the docker container
    Copy-Item -Path $YamlFile -Destination $AbsoluteOutputPath
    $BuildYmlFile = Split-Path -Leaf $YamlFile
    
    if ($PSCmdlet.ShouldProcess("$AbsoluteOutputPath")) {
        Write-Verbose "Docker command executed: docker run --rm -v `"$($AbsoluteOutputPath):/home/yamlresume`" yamlresume/yamlresume build $BuildYmlFile"
        docker run --rm -v "$($AbsoluteOutputPath):/home/yamlresume" yamlresume/yamlresume build $BuildYmlFile
    }

}