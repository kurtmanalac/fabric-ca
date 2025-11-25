#!/bin/sh

#MSP_DIR
#CA_CERT_FILE

cat > ${MSP_DIR}/config.yaml << EOF
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: ${CA_CERT_FILE}
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: ${CA_CERT_FILE}
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: ${CA_CERT_FILE}
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: ${CA_CERT_FILE}
    OrganizationalUnitIdentifier: orderer
EOF