param ([string]$predicateFile = "ccov-policy.rego")

# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

if (-not (test-path -Path $predicateFile)) {
  Write-Error "predicateFile '$predicateFile' does not exist."
  return
}

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestdigest.ps1)
$REPOPATH=(./get-repopath.ps1)
$IMAGE="$REPOPATH@$DIGEST"
$TAGGED_IMAGE="custom-alpine-0.$VERSION.0"
Write-Host "Verifying Code Coverage attestation on $TAGGED_IMAGE [$IMAGE]"
# Azure Container Registry can take a little bit to fully synchronize resulting in this
# sometimes failing even though the attestations were just recently added.
Start-Sleep -Seconds 5
cosign verify-attestation --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" $IMAGE --offline=true --insecure-ignore-tlog=true "--type=https://github.com/kalebpederson/schemas/code-coverage" --policy=$predicateFile
