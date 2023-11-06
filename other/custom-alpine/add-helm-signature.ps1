# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestchartdigest.ps1)
$REPOPATH=(./get-chartspath.ps1)
$IMAGE="$REPOPATH/custom-alpine@$DIGEST"
Write-Host "Signing helm chart for digest $IMAGE"
cosign sign --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --tlog-upload=false 

#Write-Host "Signing helm chart for version 0.$VERSION.0"
#cosign sign --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" "$($REPOPATH):0.$VERSION.0" --tlog-upload=false 

