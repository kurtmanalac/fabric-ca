#!/bin/bash
# Check if data directory is empty (first run)
if [ -z "$(ls -A /app/data)" ]; then
    echo "Initializing data directory..."
    
    # Copy from different temp locations
    cp -r /tmp/data/fabric-ca/* /app/data/fabric-ca/ 2>/dev/null || true
    
    echo "Data initialization complete"
fi

# Start your actual application (replace with your command)
exec fabric-ca-server start -b admin:adminpw
