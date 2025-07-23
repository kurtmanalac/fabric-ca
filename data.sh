#!/bin/sh

fabric-ca-server start -b admin:adminpw

node node-api/app.js