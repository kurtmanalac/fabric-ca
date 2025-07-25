#!/bin/sh

echo "$ENROLL_ID enrollment..."
mkdir -p $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp
if fabric-ca-client identity list --id $ENROLL_ID
then
    echo "$ENROLL_ID exists!"
else
    fabric-ca-client enroll -u http://$ENROLL_ID:$ENROLL_PW@localhost:7054 --mspdir $FABRIC_CA_CLIENT_HOME/$ENROLL_ID/msp $CUSTOM_CMD
    echo "$ENROLL_ID enrolled!"
fi