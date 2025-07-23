echo "Admin enrollment..."
mkdir -p $FABRIC_CA_CLIENT_HOME/admin
fabric-ca-client enroll -u http://admin:adminpw@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/admin
echo "Admin enrolled!"