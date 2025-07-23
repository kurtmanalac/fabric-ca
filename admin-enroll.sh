echo "Admin enrollment..."
mkdir -p $FABRIC_CA_CLIENT_HOME/admin/msp
fabric-ca-client enroll -u http://admin:adminpw@localhost:7054 --mspdir $FABRIC_CA_CLIENT_HOME/admin/msp
echo "Admin enrolled!"