# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$DIGEST=(./get-latestdigest.ps1)
$REPOPATH=(./get-repopath.ps1)
$IMAGE="$REPOPATH@$DIGEST"
$TAGGED_IMAGE="custom-alpine-0.$VERSION.0"
Write-Host "Generating SBOM"
syft $IMAGE -o spdx-json | out-file "$TAGGED_IMAGE.spdxjson"
Write-Host "Attesting SBOM"
# we could also generate an SBOM using `trivy image --format cyclonedx --output cyclonedx-out.json image:tag`. To include
# vulnerabilities, we can add the `--scanners vuln` parameter. Note that its basic json output is more compact and readable
# (but likely less standardized).

cosign attest --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" --predicate "$TAGGED_IMAGE.spdxjson" --type=spdxjson --tlog-upload=false $IMAGE 
