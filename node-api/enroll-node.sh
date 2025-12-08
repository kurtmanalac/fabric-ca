#!/bin/sh

echo "$ENROLL_ID enrollment..."
if [ -d "/app/data/fabric-ca-client/$ENROLL_ID" ];
then
    echo "$ENROLL_ID exists!"
else
    mkdir -p $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp
    FABRIC_CA_CLIENT_HOME=${FABRIC_CA_CLIENT_HOME:-/app/data/fabric-ca/ca-admin/msp}
    KEYFILE=$(find /app/data/fabric-ca/ca-admin/tls/keystore -type f -name '*_sk')
    fabric-ca-client register --id.name $ENROLL_ID --id.secret $ENROLL_PW -u https://github-fabric-ca.railway.internal:7054 --id.type $ID_TYPE --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem --tls.client.certfile /app/data/fabric-ca/ca-admin/tls/signcerts/cert.pem --tls.client.keyfile $KEYFILE
    sleep 5
    FABRIC_CA_CLIENT_HOME=${FABRIC_CA_CLIENT_HOME:-/app/data/fabric-ca-client}
    fabric-ca-client enroll -u https://$ENROLL_ID:$ENROLL_PW@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem
    fabric-ca-client enroll -u https://$ENROLL_ID:$ENROLL_PW@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/tls --enrollment.profile tls --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem $CUSTOM_CMD
    cp $FABRIC_CA_SERVER_HOME/tls-cert.pem $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp/tlscacerts/tls-cert.pem
    echo "$ENROLL_ID registered!"
fi