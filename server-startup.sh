#!/bin/sh

# Exit on any error
set -e

# curl -v http://fabric-tools-storage.railway.internal:8080/health

node node-api/app.js &
NODE_PID=$!

sleep 5

# mkdir -p /app/postgres
# echo -n | openssl s_client -starttls postgres -connect postgres.railway.internal:5432 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /app/postgres/ca.pem
# sleep 5
# #chmod 644 /app/postgres/ca.pem
# sleep 5
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

# include init first to isolate the first keyfile
fabric-ca-server start -b admin:adminpw &
FABRIC_PID=$!

sleep 5
chmod -R 755 /app/data/fabric-ca-server
sleep 5
./admin-init.sh

wait $NODE_PID $FABRIC_PID
