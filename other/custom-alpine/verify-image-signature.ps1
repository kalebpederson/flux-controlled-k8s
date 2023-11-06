# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestdigest.ps1)
$REPOPATH=(./get-repopath.ps1)
$IMAGE="$REPOPATH@$DIGEST"
$TAGGED_IMAGE="custom-alpine-0.$VERSION.0"
Write-Host "Verifying image signature of $TAGGED_IMAGE [$IMAGE]"
cosign verify --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --offline=true --insecure-ignore-tlog=true
