CA_URL=${CA_URL:-http://github-fabric-ca.railway.internal:8000}
CLIENT=${CLIENT:-upmoadmin}
CLIENT_PW=${CLIENT_PW:-upmomadminpw}
customCmd=${customCmd:---csr.hosts $RAILWAY_SERVICE_NAME,$RAILWAY_PRIVATE_DOMAIN --csr.names C=US,ST=California,L=SanFrancisco,O=upmo,OU=peer}
admin_json=$(jq -n --arg script "enroll-client.sh" --arg client "$CLIENT" --arg clientpw "$CLIENTPW" --arg cmd "$customCmd" --arg type "peer" '{"shellScript": $script, "envVar": {"CLIENT": $client, "CLIENT_PW": $clientpw, "ID_TYPE": $peer, "CUSTOM_CMD": $cmd}}')
curl -X POST $CA_URL/invoke-script \
    -H "Content-Type: application/json" \
    -d "$admin_json"