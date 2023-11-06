# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=(./get-version.ps1)
helm package charts --app-version "0.$VERSION.0" --version "0.$VERSION.0"
