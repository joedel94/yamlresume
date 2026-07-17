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
        [string]$Path = "./Latest"
    )
    
    try {
        #Gets the absolute path from the string provided in the parameter and creates the directory if it doesn't exist
        $AbsoluteOutputPath = Get-AbsoluteOutputPath -Path $Path
        $BuildFileName = Split-Path -Leaf $YamlFile
        $FinalBuildFile = Join-Path -Path $AbsoluteOutputPath -ChildPath $BuildFileName

        if (Test-Path -LiteralPath $FinalBuildFile) {
            if ($PSCmdlet.ShouldProcess('Remove-Item',"$FinalBuildFile")) {
                #We remove all items in the output path to ensure a clean build environment
                #We ignore confirm here so we do not double trigger a confirmation
                Get-ChildItem -LiteralPath $AbsoluteOutputPath -Recurse | Remove-Item -Confirm:$false
            }
            else {
                New-Item -Path $AbsoluteOutputPath -Name $Path -ItemType Directory
            }
        }
        else {
            #Moves target resume .yml file to the output path so it can be referenced by the docker container
            Copy-Item -Path $YamlFile -Destination $AbsoluteOutputPath
        }
    }
    catch {
        Write-Error "An error occurred while setting up build: $($_.Exception.Message)"
    }
    
    if ($PSCmdlet.ShouldProcess("$AbsoluteOutputPath")) {
        Write-Verbose "Docker command executed: docker run --rm -v `"$($AbsoluteOutputPath):/home/yamlresume`" yamlresume/yamlresume build $BuildYmlFile"
        docker run --rm -v "$($AbsoluteOutputPath):/home/yamlresume" yamlresume/yamlresume build $BuildYmlFile
    }

}