# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestdigest.ps1)
$REPOPATH=(./get-repopath.ps1)
$IMAGE="$REPOPATH@$DIGEST"
Write-Host "Signing image $IMAGE"
cosign sign --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --tlog-upload=false 
