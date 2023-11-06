#!/usr/bin/env bash
set -e

# oras repo ls is disallowed because it's ttl.sh-
#
REGISTRY="kppmetadatatesting.azurecr.io"
USER_NAME="00000000-0000-0000-0000-000000000000"
PASSWORD=$(az acr login --name $REGISTRY --expose-token --output tsv --query accessToken)
REPOPATH="$REGISTRY/kaleb/98456748971649817436/custom-alpine"

echo "Logging in to $REGISTRY"
echo -n "$PASSWORD" | oras login $REGISTRY --username $USER_NAME --password-stdin

echo "Listing repo $REPOPATH"
oras repo ls $REPOPATH

echo "Listing repo tags $REPOPATH"
TAGS=$(oras repo tags $REPOPATH) 
echo $TAGS

$LASTATT=$(echo $TAGS | grep \.att | tail -n 1)
$LASTSIG=$(echo $TAGS | grep \.sig | tail -n 1)

echo "Listing attestation primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTATT --descriptor

echo "Listing attestation manifest"
oras manifest fetch --pretty $REPOPATH:$LASTATT

echo "Listing signature primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTSIG --descriptor

echo "Listing signature manifest"
oras manifest fetch --pretty $REPOPATH:$LASTSIG

mkdir -p ./out > /dev/null 2>&1

