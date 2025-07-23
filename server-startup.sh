#!/bin/sh

fabric-ca-server start -b admin:adminpw &
FABRIC_CA_PID=$!

./admin-enroll.sh &
ADMIN_ENROLL_PID=$!

wait $FABRIC_CA_PID $ADMIN_ENROLL_PID 

node node-api/app.js &
NODE_PID=$!
