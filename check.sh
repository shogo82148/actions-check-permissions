#!/usr/bin/env bash

set -ue

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "::group::checking read permission"
echo "checking read permission..."

# try to list matching references
STATUS_CODE=$(curl \
  -X GET \
  -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GITHUB_TOKEN" \
  "$GITHUB_API_URL/repos/$GITHUB_REPOSITORY/git/matching-refs/ref" \
  -o "$TMPDIR/result.json" \
  -w '%{http_code}' \
  -sS )

echo "the returned status code is $STATUS_CODE"

if [[ "$STATUS_CODE" != "200" ]]
then
    echo "permission=none" >> "$GITHUB_OUTPUT"
    echo "::endgroup::"
    echo "the permission is none"
    exit 0
fi

echo "::endgroup::"

echo "::group::checking write permission"
echo "checking write permission..."

# try to create empty blob
STATUS_CODE=$(curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GITHUB_TOKEN" \
  "$GITHUB_API_URL/repos/$GITHUB_REPOSITORY/git/blobs" \
  -d '{"content":""}' \
  -o "$TMPDIR/result.json" \
  -w '%{http_code}' \
  -sS )

echo "the returned status code is $STATUS_CODE"

SHA=$(jq -r .sha < "$TMPDIR/result.json")

echo "::endgroup::"

if [[ "$STATUS_CODE" == "201" && "$SHA" == "e69de29bb2d1d6434b8b29ae775ad8c2e48c5391" ]]
then
    echo "permission=write" >> "$GITHUB_OUTPUT"
    echo "the permission is write"
else
    echo "permission=read" >> "$GITHUB_OUTPUT"
    echo "the permission is read"
fi
