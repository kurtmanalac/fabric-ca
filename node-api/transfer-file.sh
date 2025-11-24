#!/bin/sh

# Exit on any error
set -e

# --- CONFIGURATION ---
#SOURCE_URL
#SOURCE_FOLDER
#FOLDER_NAME
zip_json=$(jq -n --arg src "$SOURCE_FOLDER" '{sourceFolder: $src, zipPath: ($src+".zip")}')

echo "Zipping MSP files from $SOURCE_FOLDER..."
curl -X POST $SOURCE_URL/zip-folder \
    -H "Content-Type: application/json" \
    -d "$zip_json"  &
ZIP_PID=$!
wait $ZIP_PID

mkdir -p $SOURCE_FOLDER
curl -o $SOURCE_FOLDER/$FOLDER_NAME.zip $SOURCE_URL$SOURCE_FOLDER.zip &
COPY_PID=$!
wait $COPY_PID

echo "deleting zip file from $source..."
curl -X POST $SOURCE_URL/invoke-script \
    -H "Content-Type: application/json" \
    -d '{
        "shellScript": "clean-zip.sh",
        "envVar": {
            "CLEAN_ID_ZIP": "$SOURCE_FOLDER.zip"
            }
        }' &
CLEAN_PID=$!
wait $CLEAN_PID

unzip -o $SOURCE_FOLDER/$FOLDER_NAME.zip -d $SOURCE_FOLDER/ &
UNZIP_PID=$!
wait $UNZIP_PID
rm -r $SOURCE_FOLDER/$FOLDER_NAME.zip