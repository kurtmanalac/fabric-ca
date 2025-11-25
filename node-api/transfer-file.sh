#!/bin/sh

# Exit on any error
set -e

# --- CONFIGURATION ---
#SOURCE_URL
#SOURCE_FOLDER
#FOLDER_NAME
zip_json=$(jq -n --arg src "$SOURCE_FOLDER" '{sourceFolder: $src, zipPath: ($src+".zip")}')
clean_json=$(jq -n --arg script "clean-zip.sh" --arg folder "$SOURCE_FOLDER.zip" '{"shellScript": $script, "envVar": {"CLEAN_ID_ZIP": $folder}}')

echo "Zipping MSP files from $SOURCE_FOLDER..."
curl -X POST $SOURCE_URL/zip-folder \
    -H "Content-Type: application/json" \
    -d "$zip_json" 

sleep 5

echo "$SOURCE_URL$SOURCE_FOLDER"
mkdir -p $SOURCE_FOLDER
curl -f -# -o $SOURCE_FOLDER/$FOLDER_NAME.zip $SOURCE_URL$SOURCE_FOLDER.zip 

sleep 5

echo "deleting zip file from $SOURCE_URL..."
curl -X POST $SOURCE_URL/invoke-script \
    -H "Content-Type: application/json" \
    -d "$clean_json" 

unzip -o $SOURCE_FOLDER/$FOLDER_NAME.zip -d $SOURCE_FOLDER/ 

rm -r $SOURCE_FOLDER/$FOLDER_NAME.zip