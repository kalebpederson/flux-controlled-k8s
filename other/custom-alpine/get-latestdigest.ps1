# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(get-content .digests | sls "0.$VERSION.0" | select-object -Expand Line).Split(" ")[2]
$DIGEST
