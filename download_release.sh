#!/usr/bin/env bash

# Authorize to GitHub to get the latest release tar.gz
# Requires: oauth token, https://help.github.com/articles/creating-an-access-token-for-command-line-use/
# Requires: jq package to parse json

# Your oauth token goes here, see link above
OAUTH_TOKEN="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"
# Repo owner (user id)
OWNER="civcraft-ru"
# Repo name
REPO="civcraft-plugin"
# The file name expected to download. This is deleted before curl pulls down a new one
FILE_NAME="CivCraft-1.0.0.jar"

# Concatenate the values together for a 
API_URL="https://$OAUTH_TOKEN:@api.github.com/repos/$OWNER/$REPO"

# Gets info on latest release, gets first uploaded asset id of a release,
# More info on jq being used to parse json: https://stedolan.github.io/jq/tutorial/
ASSET_ID=$(curl $API_URL/releases/latest | jq -r '.assets[0].id')
echo "Asset ID: $ASSET_ID"

# curl does not allow overwriting file from -O, nuke
rm -f $FILE_NAME

# curl:
# -O: Use name provided from endpoint
# -J: "Content Disposition" header, in this case "attachment"
# -L: Follow links, we actually get forwarded in this request
# -H "Accept: application/octet-stream": Tells api we want to dl the full binary
(cd plugins && curl -O -J -L -H "Accept: application/octet-stream" "$API_URL/releases/assets/$ASSET_ID")
