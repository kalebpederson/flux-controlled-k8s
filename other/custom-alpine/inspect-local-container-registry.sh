#!/usr/bin/env bash
set -e

# oras repo ls is disallowed because it's ttl.sh-
#
REGISTRY="ttl.sh"
USER_NAME="00000000-0000-0000-0000-000000000000"
#PASSWORD=$(az acr login --name $REGISTRY --expose-token --output tsv --query accessToken)
PASSWORD=""
REPOPATH="$REGISTRY/kaleb/98456748971649817436/custom-alpine"
CHARTPATH="$REGISTRY/kaleb/98456748971649817436/charts"

echo "Logging in to $REGISTRY"
#echo -n "$PASSWORD" | oras login $REGISTRY --username $USER_NAME --password-stdin

echo "Listing repo $REPOPATH"
#oras repo ls $REPOPATH

echo "Listing repo tags $REPOPATH"
TAGS=$(oras repo tags $REPOPATH) 
echo "$TAGS"

echo "Listing helm chart repo tags $CHARTPATH"
CHARTTAGS=$(oras repo tags $CHARTPATH) 
echo "$CHARTTAGS"

LASTTAG=$(echo "$TAGS" | grep -E "^0\.[0-9]+\.0$" | tail -n 1)
LASTATT=$(echo "$TAGS" | grep \.att | tail -n 1)
LASTSIG=$(echo "$TAGS" | grep \.sig | tail -n 1)

LASTCHARTSIG=$(echo "$CHARTTAGS" | grep \.sig | tail -n 1)

echo "Last chart SIG: $LASTCHARTSIG"

echo "Listing image attestation primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTATT --descriptor

echo "Listing image attestation manifest"
ATTMANIFEST=$(oras manifest fetch --pretty $REPOPATH:$LASTATT)
echo "$ATTMANIFEST"

echo "Listing image signature primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTSIG --descriptor

echo "Listing image signature manifest"
SIGMANIFEST=$(oras manifest fetch --pretty $REPOPATH:$LASTSIG)
echo "$SIGMANIFEST"

echo "Getting image attestation payloads"
for x in spdxjson vuln 'https://github.com/kalebpederson/schemas/code-coverage' ; do
    echo "Examining predicate type: '$x'"
    cosign.exe download attestation --predicate-type="$x" "$REPOPATH:$LASTTAG" | jq
done

echo "Listing helm signature primary descriptor"
oras manifest fetch --pretty $CHARTPATH:$LASTCHARTSIG --descriptor

echo "Listing helm signature manifest"
CHARTSIGMANIFEST=$(oras manifest fetch --pretty $CHARTPATH:$LASTCHARTSIG)
echo "$CHARTSIGMANIFEST"

mkdir -p ./out > /dev/null 2>&1

