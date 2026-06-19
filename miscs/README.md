# Miscellaneous Community Contributions

This directory contains valuable community contributions that extend YAML Resume
functionality into windows environments using a lightweight PowerShell module.

## YAMLResume

YAMLResume provides helper functions to build a resume from a YAML file and to generate a new YAML resume example file using Windows Docker desktop and the YAML Resume CLI.

**Contributed by:** [@webJose](https://github.com/webJose) and [@joedel94](https://github.com/joedel94)
[#64](https://github.com/yamlresume/yamlresume/issues/64), original YamlResume module design
[!](https://github.com/yamlresume/yamlresume/) 


### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) must be installed.
- YamlResume [Docker container](https://yamlresume.dev/docs#docker-users) running. 

### Usage

Import the module from the YAMLResume installed directory, note you will need to copy the content out of the [YAMLResume Github](https://github.com/yamlresume/yamlresume) repository or `clone` it using `git`:
```powershell
#example including git clone
Set-Location - Path 'C:\Some\Install\Path\'
git clone 'https://github.com/yamlresume/yamlresume.git'
#Note this does not install the module for long term use and will be available only in this PowerShell session 
Import-Module '.\miscs\YAMLResume.psm1'
```

#### Create a New YAML Resume File

```powershell
# Create with default name (my-resume.yml)
New-YamlResume

# Create with custom name
New-YamlResume custom.yml
```

#### Build a Resume

```powershell
# Build with defaults (my-resume.yml -> ./Latest)
Build-YamlResume

# Build with custom input and output
Build-YamlResume -YamlFile "custom.yml" -OutputPath "./2025-11-01"
```

> **Note:** All paths must be relative paths.
