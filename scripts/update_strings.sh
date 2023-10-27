#!/bin/bash

PROJECT_ID=$LOKALISE_PROJECT_ID
API_TOKEN=$LOKALISE_API_TOKEN

echo 'Checking if "jq" command is available'
if ! [[ $(command -v jq) ]]; then
  echo "'jq' is not installed. Install 'jq' via 'brew install jq' or your OS's respective dependency manager's command"
  exit 1
fi

echo 'Checking if there are uncommitted changes'
if [[ $(git diff --stat) != '' ]]; then
  echo 'You have uncommited changes. Clean those up first.'
  exit 1
fi

if [[ $1 == "info-plist" ]]; then
  echo 'Retrieving export settings for the infoPlist export'
  EXPORT_SETTINGS='
    {
      "include_tags": ["info-plist"],
      "format": "strings",
      "original_filenames": false,
      "bundle_structure": "../App/SupportingFiles/%LANG_ISO%.lproj/InfoPlist.%FORMAT%"
    }
  '
  COMMIT_MSG='Update InfoPlist.strings'
elif ! [[ -z "$1"  ]]; then
  echo "Error. Provided unknown param: $1"
  exit 1
else
  echo 'Fallback export settings for all other strings'
  EXPORT_SETTINGS='
    {
      "exclude_tags": [
        "info-plist"
      ],
      "format": "strings",
      "placeholder_format": "ios",
      "export_empty_as": "empty",
      "indentation": "2sp",
      "original_filenames": false,
      "bundle_structure": "../App/Resources/%LANG_ISO%.lproj/Localizable.%FORMAT%"
    }
  '
  COMMIT_MSG='Update app strings'
fi

echo 'Trigger Lokalise export...'
BUNDLE_URL=$(curl --request POST \
     --url https://api.lokalise.com/api2/projects/$PROJECT_ID/files/download \
     --header "X-Api-Token: $API_TOKEN" \
     --header 'accept: application/json' \
     --header 'content-type: application/json' \
     --data "${EXPORT_SETTINGS}" 2>/dev/null | jq -r .bundle_url)

TEMP_ZIP_FILE='tmp_strings.zip'

echo 'Downloading zip file into temporary file'
curl $BUNDLE_URL -o $TEMP_ZIP_FILE 2>/dev/null

echo 'Unzipping file'
unzip -o $TEMP_ZIP_FILE >/dev/null

echo 'Removing temporary zip file'
rm $TEMP_ZIP_FILE

if [[ $(git diff --stat) == '' ]]; then
  echo 'There are no new text changes'
else
  echo 'Committing changes'
  git add -u && git commit -m "${COMMIT_MSG}"
fi
