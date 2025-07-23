#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

wait $FABRIC_CA_PID 

./admin-enroll.sh &
ADMIN_ENROLL_PID=$!

wait $ADMIN_ENROLL_PID

node node-api/app.js &
NODE_PID=$!

wait $NODE_PID
