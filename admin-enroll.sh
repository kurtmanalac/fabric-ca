echo "Admin enrollment..."
mkdir -p $FABRIC_CA_CLIENT_HOME/admin/msp
if fabric-ca-client identity list --id admin
    fabric-ca-client enroll -u http://admin:adminpw@localhost:7054 --mspdir $FABRIC_CA_CLIENT_HOME/admin/msp
fi
echo "Admin enrolled!"