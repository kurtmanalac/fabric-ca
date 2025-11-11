#!/bin/sh

echo "CA Admin enrollment..."
mkdir -p $FABRIC_CA_HOME/ca-admin/msp
if fabric-ca-client identity list --id admin
then
    echo "Admin exists!"
else
    fabric-ca-client enroll -u http://admin:adminpw@localhost:7054 --mspdir $FABRIC_CA_HOME/ca-admin/msp
    echo "Admin enrolled!"
    # copy files to storage
    
fi