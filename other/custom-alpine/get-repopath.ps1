# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$REPOPATH=(get-content .repopath).Trim()
$REPOPATH
