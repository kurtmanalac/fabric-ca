#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

node node-api/app.js &
NODE_PID=$!

wait $FABRIC_CA_PID $NODE_PID
mkdir -p $FABRIC_CA_CLIENT_HOME/admin
fabric-ca-client enroll -u http://admin:adminpw@github-fabric-ca.railway.internal:7054 --mspdir $FABRIC_CA_CLIENT_HOME/admin
