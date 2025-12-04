#!/bin/sh

echo "$ENROLL_ID enrollment..."
if [ -d "/app/data/fabric-ca-client/$ENROLL_ID" ];
then
    echo "$ENROLL_ID exists!"
else
    mkdir -p $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp
    fabric-ca-client register --id.name $ENROLL_ID --id.secret $ENROLL_PW --id.type $ID_TYPE
    fabric-ca-client enroll -u https://$ENROLL_ID:$ENROLL_PW@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp $CUSTOM_CMD --tls.certfiles /app/data/fabric-ca-server/tls-cert.pem
    echo "$ENROLL_ID enrolled!"
fi