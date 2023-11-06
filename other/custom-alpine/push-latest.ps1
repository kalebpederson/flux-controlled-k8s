# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$REPOPATH=(./get-repopath.ps1)
docker push "$($REPOPATH):0.$VERSION.0" | sls "digest:" | select-object -Expand Line | out-file -append .digests
get-content .digests | select-object -last 1
