# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
$IMAGEDIGEST=(./get-latestdigest.ps1)

# update values file to include the image digest
(Get-Content charts\values.yaml) -replace 'digest: .*', "digest: `"$IMAGEDIGEST`"" | Set-Content charts\values.yaml

# package the helm chart
helm package charts --app-version "0.$VERSION.0" --version "0.$VERSION.0"
