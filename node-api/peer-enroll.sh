#!/bin/sh

echo "$ENROLL_ID enrollment..."
if [ -d "/app/data/fabric-ca-client/$ENROLL_ID" ];
then
    echo "$ENROLL_ID exists!"
else
    mkdir -p $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp
    fabric-ca-client register --id.name $ENROLL_ID --id.secret $ENROLL_PW --id.type peer
    fabric-ca-client getcainfo -u http://0.0.0.0:7054 > /app/data/fabric-ca-client/peer1/msp/cacerts/github-fabric-ca.railway.internal-7054.pem
    fabric-ca-client enroll -u http://$ENROLL_ID:$ENROLL_PW@0.0.0.0:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp $CUSTOM_CMD
    echo "$ENROLL_ID enrolled!"
fi