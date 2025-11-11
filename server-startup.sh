#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

node node-api/app.js &
NODE_PID=$!

sleep 5

./admin-init.sh &
ADMIN_ENROLL_PID=$!

wait $FABRIC_CA_PID $NODE_PID $ADMIN_ENROLL_PID
