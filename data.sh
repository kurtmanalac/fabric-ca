#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

node node-api/app.js &
NODE_PID=$!

wait $FABRIC_CA_PID $NODE_PID