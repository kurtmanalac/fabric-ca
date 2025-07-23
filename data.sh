#!/bin/bash

exec fabric-ca-server start -b admin:adminpw && python3 -m http.server 8000
