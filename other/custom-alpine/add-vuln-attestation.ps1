# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestdigest.ps1)
$REPOPATH=(./get-repopath.ps1)
$IMAGE="$REPOPATH@$DIGEST"
$TAGGED_IMAGE="custom-alpine-0.$VERSION.0"

Write-Host "Generating the vulnerability report on $TAGGED_IMAGE"
# Note also that we can give trivy custom Rego policies to verify when scanning the image.
# see: https://aquasecurity.github.io/trivy/v0.19.2/misconfiguration/custom/
trivy image --format cosign-vuln --output $TAGGED_IMAGE-vuln.json $IMAGE

Write-Host "Attesting vulnerability report"
cosign attest --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" --predicate $TAGGED_IMAGE-vuln.json "--type=vuln" --tlog-upload=false $IMAGE
