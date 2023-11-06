param ([string]$predicateFile = "ccov-results.json")

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
Write-Host "Attesting code coverage using $predicateFile"
# NOTE: If "--type" is custom, then the predicateFile contents are a string that is placed into the predicate.
# However, if --type is set to a URI, then the contents are assumed to be JSON which is inlined into the predicate content
# which enables it to be queried as structured data/JSON within the Cue and Rego policies.
cosign attest --key "azurekms://cosign-storage-kv2.vault.azure.net/cosignkey" --predicate $predicateFile "--type=https://github.com/kalebpederson/schemas/code-coverage" --tlog-upload=false $IMAGE
