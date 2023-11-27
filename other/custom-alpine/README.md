# Prerequisites

1. Need write access to the OCI repository that will be used to store images and helm charts.
1. Need az-cli connected to the subscription containing the Azure Key Vault from which the signing key will be pulled.
1. Logged into helm using `helm login`. 
1. Logged into docker using `docker login`
1. .chartspath should point to the directory into which the charts will be pushed.
1. .repopath should point to the directory into which the container images will be pushed.
1. [Optional] If repository contents are going to be inspected, you must also log into oras using `oras login`.

# Complete Steps

To run all the steps at once without any intervention or break between them, run the `./do-all.ps1` script. Otherwise,
perform the steps listed below.

## Step 1 - Prepare the container image

### Build the image

This builds a new version of the application by incrementing the minor version. If no version was previously built and
.version does not exist, the version will start at 0.1.0.

    ./build-newversion.ps1

### Push the image to OCI repository

Push the just-built container image to the OCI repository defined in .repopath.

    ./push-latest.ps1

### Sign the container image

Use cosign to sign the container image with the private key specified in the Azure Key Vault.

    ./add-image-signature.ps1

## Step 2 - Add Attestations to the image

Attestations are facts about the image that have been attested by the owner of the key that
performed the attesting. They are attached to the attestations file that accompanies the OCI
image being attested.

### Add Software Bill of Materials Attestation

Adds a software bill of materials (SBOM) attestation to the image. That SBOM is generated
using `syft` in SPDX JSON format. Attestations in JSON format are inlined directly into
predicate contained in the base64 encoded payload included in the attestation envelope.

    ./add-sbom-attestation.ps1

### Add Vulnerability Report Attestation

Adds a vulnerability report attestation to the image. The vulnerability report is generated
using `trivy` in the cosign-vuln JSON report format allowing in to be inlined into the
payload's predicate.

    ./add-vuln-attestation.ps1

### Add Code Coverage Report Attestation

Cosign doesn't have a standard that it accepts for code coverage. For simplicity, this step
attaches a custom JSON file using `--type <URI>` to allow the content to be encoded as JSON.

    ./add-custom-ccov-attestation.ps1

## Step 3 - Prepare Helm Charts

### Package the Helm Charts

    ./helm-package.ps1

### Push the Helm Chart    

    ./helm-push.ps1

### Sign the Helm Chart

    ./add-helm-signature.ps1

## Step - Verify Signatures and Attestations

### Verify the signature on the Helm charts

./verify-helm-signature.ps1

### Verify the signature on the container image

./verify-image-signature.ps1

### Verify the Software Bill of Materials Attestation

./verify-sbom-attestation.ps1

### Verify the Vulnerability Attestation

./verify-vuln-attestation.ps1

### Verify the Code Coverage Attestation

./verify-custom-ccov-attestation.ps1
