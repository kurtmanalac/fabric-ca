#!/bin/sh

echo "$CLIENT enrollment..."
if [ -d "/app/data/fabric-ca-client/$CLIENT" ];
then
    echo "$CLIENT exists!"
else
    mkdir -p $FABRIC_CA_CLIENT_HOME/$CLIENT/msp
    fabric-ca-client register --id.name $CLIENT --id.secret $CLIENT_PW -u https://github-fabric-ca.railway.internal:7054 --id.type $ID_TYPE
    sleep 5
    FABRIC_CA_CLIENT_HOME=${FABRIC_CA_CLIENT_HOME:-/app/data/fabric-ca-client}
    fabric-ca-client enroll -u https://$CLIENT:$CLIENT_PW@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$CLIENT/tls --enrollment.profile tls --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem $CUSTOM_CMD
    fabric-ca-client enroll -u https://$CLIENT:$CLIENT_PW@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$CLIENT/msp --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem $CUSTOM_CMD
    mkdir -p $FABRIC_CA_CLIENT_HOME/$CLIENT/msp/tlscacerts
    cp $FABRIC_CA_SERVER_HOME/ca-cert.pem $FABRIC_CA_CLIENT_HOME/$CLIENT/msp/tlscacerts/tls-cert.pem
    mv $FABRIC_CA_CLIENT_HOME/$CLIENT/msp/cacerts/github-fabric-ca-railway-internal-7054.pem $FABRIC_CA_CLIENT_HOME/$CLIENT/msp/cacerts/ca-cert.pem
    # rm -r $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp/cacerts/github-fabric-ca-railway-internal-7054.pem
    # cp $FABRIC_CA_SERVER_HOME/ca-cert.pem $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp/cacerts/ca-cert.pem
    echo "$CLIENT registered!"
    # generate nodeOUs
    CA_URL=${CA_URL:-http://github-fabric-ca.railway.internal:8000}
    MSP_DIR=${MSP_DIR:-$FABRIC_CA_CLIENT_HOME/$CLIENT/msp}
    CA_CERT_FILE=${CA_CERT_FILE:-cacerts/ca-cert.pem}
    nodeou_json=$(jq -n --arg script "nodeOU-create.sh" --arg msp "$MSP_DIR" --arg cert "$CA_CERT_FILE" '{"shellScript": $script, "envVar": {"MSP_DIR": $msp, "CA_CERT_FILE": $cert}}')
    curl -X POST $CA_URL/invoke-script \
        -H "Content-Type: application/json" \
        -d "$nodeou_json"

    sleep 5
fi