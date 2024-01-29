# error out if any of the steps fail
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$VERSION=((./get-version.ps1)+1)
$REPOPATH=(./get-repopath.ps1)
write-host docker build . --build-arg CACHEBUST=$(Get-Random) --tag custom-alpine:latest --tag "$($REPOPATH):0.$VERSION.0"
docker build . --build-arg CACHEBUST=$(Get-Random) --tag custom-alpine:latest --tag "$($REPOPATH):0.$VERSION.0"
echo $VERSION > .version
