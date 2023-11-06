# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

if (-not (Test-Path .version)) {
  $VERSION=1
  $VERSION | out-file .version
} else {
  $VERSION=([System.Int32](get-content .version))
}
$VERSION
