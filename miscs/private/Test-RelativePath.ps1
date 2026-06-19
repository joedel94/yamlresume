# Private helper: checks if a path is relative and throws if not
function Test-RelativePath {
    param([string]$Path, [string]$ParamName)
    if ([System.IO.Path]::IsPathRooted($Path)) {
        throw "$ParamName must be a relative path."
    }
}