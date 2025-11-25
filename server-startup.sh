#!/bin/sh

# Exit on any error
set -e

curl -v http://fabric-tools-storage.railway.internal:8080/health

node node-api/app.js &
NODE_PID=$!

sleep 5

SOURCE_URL=${SOURCE_URL:-http://fabric-tools-storage.railway.internal:8080}
SOURCE_FOLDER=${SOURCE_FOLDER:-/app/data}
FOLDER_NAME=data
temp_URL=${temp_URL:-http://github-fabric-ca.railway.internal:8000}
transfer_json=$(jq -n --arg script "transfer-file.sh" --arg url "$SOURCE_URL" --arg folder "$SOURCE_FOLDER" --arg name "$FOLDER_NAME" '{"shellScript": $script, "envVar": {"SOURCE_URL": $url, "SOURCE_FOLDER": $folder, "FOLDER_NAME": $name}}')
echo "Transferring files..."
curl -X POST $temp_URL/invoke-script \
    -H "Content-Type: application/json" \
    -d "$transfer_json"

sleep 5

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

./admin-init.sh

wait $NODE_PID $FABRIC_CA_PID
