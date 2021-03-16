#!/usr/bin/env bash

set -ue

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# try to create empty blob
STATUS_CODE=$(curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/shogo82148/actions-check-permissions/git/blobs \
  -d '{"content":""}' \
  -o "$TMPDIR/result.json" \
  -w '%{http_code}' \
  -sS )

SHA=$(jq -r .sha < "$TMPDIR/result.json")

if [[ "$STATUS_CODE" == "201" && "$SHA" == "e69de29bb2d1d6434b8b29ae775ad8c2e48c5391" ]]
then
    echo "::set-output name=permission::write"
else
    echo "::set-output name=permission::read"
fi
