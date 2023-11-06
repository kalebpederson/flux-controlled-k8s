# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestchartdigest.ps1)
$CHARTSPATH=(./get-chartspath.ps1)
$IMAGE="$CHARTSPATH/custom-alpine@$DIGEST"
$TAGGED_IMAGE="custom-alpine-0.$VERSION.0"
Write-Host "Verifying helm chart signature of $TAGGED_IMAGE [$IMAGE]"
cosign verify --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --offline=true --insecure-ignore-tlog=true

#Write-Host "Verifying helm chart signature of $TAGGED_IMAGE [$IMAGE]"
#cosign verify --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --offline=true --insecure-ignore-tlog=true

