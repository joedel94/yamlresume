function Build-YamlResume {
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
    param(
        [Parameter(Position = 0)]
        [string]$YamlFile = "my-resume.yml",
        [Parameter(Position = 1)]
        [string]$OutputPath = "./Latest"
    )
    try {
        Test-RelativePath $YamlFile 'YamlFile'
        Test-RelativePath $OutputPath 'OutputPath'
    }
    catch {
        Write-Error $_
        return
    }

    if (-not (Test-Path $YamlFile -PathType Leaf)) {
        Write-Error "YamlFile '$YamlFile' not found."
        return
    }

    $absoluteOutputPath = Get-AbsoluteOutputPath $OutputPath

    if (Test-Path $absoluteOutputPath) {
        Get-ChildItem -Path $absoluteOutputPath | Remove-Item -Recurse -Force
    }

    Copy-Item -Path $YamlFile -Destination $absoluteOutputPath -Force
    $containerFile = Split-Path -Leaf $YamlFile
    Write-Verbose "About to execute: docker run --rm -v `"$($absoluteOutputPath):/home/yamlresume`" yamlresume/yamlresume build $containerFile"
    docker run --rm -v "$($absoluteOutputPath):/home/yamlresume" yamlresume/yamlresume build $containerFile
}