# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$CHARTSPATH=(get-content .chartspath).Trim()
$CHARTSPATH
