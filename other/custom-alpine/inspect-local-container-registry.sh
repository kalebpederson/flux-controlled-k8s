#!/usr/bin/env bash
set -e

# oras repo ls is disallowed because it's ttl.sh-
#
REGISTRY="localhost:5000"
USER_NAME="00000000-0000-0000-0000-000000000000"
#PASSWORD=$(az acr login --name $REGISTRY --expose-token --output tsv --query accessToken)
PASSWORD=""
REPOPATH="$REGISTRY/kaleb/98456748971649817436/custom-alpine"

echo "Logging in to $REGISTRY"
#echo -n "$PASSWORD" | oras login $REGISTRY --username $USER_NAME --password-stdin

echo "Listing repo $REPOPATH"
oras repo ls $REPOPATH

echo "Listing repo tags $REPOPATH"
TAGS=$(oras repo tags $REPOPATH) 
echo "$TAGS"

LASTTAG=$(echo "$TAGS" | grep -E "^0\.[0-9]+\.0$" | tail -n 1)
LASTATT=$(echo "$TAGS" | grep \.att | tail -n 1)
LASTSIG=$(echo "$TAGS" | grep \.sig | tail -n 1)

echo "Listing attestation primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTATT --descriptor

echo "Listing attestation manifest"
ATTMANIFEST=$(oras manifest fetch --pretty $REPOPATH:$LASTATT)
echo "$ATTMANIFEST"

echo "Listing signature primary descriptor"
oras manifest fetch --pretty $REPOPATH:$LASTSIG --descriptor

echo "Listing signature manifest"
SIGMANIFEST=$(oras manifest fetch --pretty $REPOPATH:$LASTSIG)
echo "$SIGMANIFEST"

echo "Getting attestation payloads"
echo "$ATTMANIFEST" | grep '"predicateType"' | cut -d'"' -f4 | sed 's/"//g' | while read ; do
    echo "Found predicate type: '$REPLY'"
    cosign.exe download attestation --predicate-type="$REPLY" "localhost:5000/kaleb/98456748971649817436/custom-alpine:$LASTTAG" | jq
done

mkdir -p ./out > /dev/null 2>&1

