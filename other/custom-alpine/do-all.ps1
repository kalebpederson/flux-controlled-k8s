# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# build and push the new version to the container registry
.\build-newversion.ps1
.\push-latest.ps1
# add image signature and attestations to the remote container registry
.\add-image-signature.ps1
.\add-sbom-attestation.ps1
.\add-vuln-attestation.ps1
.\add-custom-ccov-attestation.ps1
# create, sign, and push helm charts to the remote container registry
.\helm-package.ps1
.\helm-push.ps1
.\add-helm-signature.ps1
# verify helm chart signature
.\verify-helm-signature.ps1
# verify image signature and attestations
.\verify-image-signature.ps1
.\verify-sbom-attestation.ps1
.\verify-vuln-attestation.ps1
.\verify-custom-ccov-attestation.ps1
