# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$CHARTSPATH=(./get-chartspath.ps1)
echo "Pushing custom-alpine-0.$VERSION.0.tgz to oci://$CHARTSPATH"
$DIGEST=(helm push .\custom-alpine-0.$VERSION.0.tgz oci://$CHARTSPATH 2>&1 | sls "digest:" | select-object -Expand Line)
echo "custom-alpine-0.$VERSION.0: $DIGEST" | out-file -append .helm-digests
get-content .helm-digests | select-object -last 1
