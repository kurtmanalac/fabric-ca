#!/bin/sh

echo "CA Admin enrollment..."
if [ -d "$FABRIC_CA_HOME/ca-admin" ];
then
    echo "Admin exists!"
else
    mkdir -p $FABRIC_CA_HOME/ca-admin/msp
    fabric-ca-client enroll -u https://admin:adminpw@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_HOME/ca-admin/msp --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem
    # find /app/data/fabric-ca/ca-admin/msp/keystore/ -type f -name '*_sk' -exec rm {} \;
    fabric-ca-client enroll -u https://admin:adminpw@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_HOME/ca-admin/msp --csr.hosts $RAILWAY_PRIVATE_DOMAIN,$RAILWAY_SERVICE_NAME --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem --enrollment.profile tls
    find /app/data/fabric-ca-server/msp/keystore/ -type f -name '*_sk' -print0 | xargs -0 ls -t | tail -n +2 | xargs rm -f
    echo "Admin enrolled!"
    mkdir -p $FABRIC_CA_HOME/ca-admin/msp/tlscacerts
    # cp $FABRIC_CA_SERVER_HOME/tls-cert.pem $FABRIC_CA_HOME/ca-admin/msp/tlscacerts/tls-cert.pem
    # copy files to storage
    SOURCE_URL=${SOURCE_URL:-http://github-fabric-ca.railway.internal:8000}
    SOURCE_FOLDER=${SOURCE_FOLDER:-/app/data}
    FOLDER_NAME=data
    temp_URL=${temp_URL:-http://fabric-tools-storage.railway.internal:8080}
    transfer_json=$(jq -n --arg script "transfer-file.sh" --arg url "$SOURCE_URL" --arg folder "$SOURCE_FOLDER" --arg name "$FOLDER_NAME" '{"shellScript": $script, "envVar": {"SOURCE_URL": $url, "SOURCE_FOLDER": $folder, "FOLDER_NAME": $name}}')
    echo "Transferring files..."
    curl -X POST $temp_URL/invoke-script \
        -H "Content-Type: application/json" \
        -d "$transfer_json" &
    TRANSFER_PID=$!
    wait $TRANSFER_PID
fi