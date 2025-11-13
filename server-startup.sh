#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

node node-api/app.js &
NODE_PID=$!

wait $FABRIC_CA_PID $NODE_PID
sleep 5

SOURCE_URL=${SOURCE_URL:-http://fabric-tools-storage.railway.internal:8000}
SOURCE_FOLDER=${SOURCE_FOLDER:-/app/data}
FOLDER_NAME=${FOLDER_NAME:-data}
temp_URL=${temp_URL:-http://github-fabric-ca.railway.internal:8000}
transfer_json=$(jq -n --arg script "transfer-file.sh" --arg url "$SOURCE_URL" --arg pw "$SOURCE_FOLDER" --arg cmd "$FOLDER_NAME" '{shellScript: $script, envVar: {SOURCE_URL: $url, SOURCE_FOLDER: $folder, FOLDER_NAME: $name}}')
echo "Transferring files..."
curl -X POST $temp_URL/invoke_script \
    -H "Content-Type: application/json" \
    -d "$transfer_json" &
TRANSFER_PID=$!
wait $TRANSFER_PID

./admin-init.sh &
ADMIN_ENROLL_PID=$!

wait $ADMIN_ENROLL_PID
