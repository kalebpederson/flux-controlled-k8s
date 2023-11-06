# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

flux suspend helmrelease custom-alpine-helm-release #> $nul
flux resume helmrelease custom-alpine-helm-release #> $nul
