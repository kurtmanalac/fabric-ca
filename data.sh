#!/bin/bash
# Check if data directory is empty (first run)
if [ -z "$(ls -A /app/data)" ]; then
    echo "Initializing data directory..."
    
    # Copy from different temp locations
    cp -r /tmp/data/fabric-ca-server/* /app/data/fabric-ca-server/ 2>/dev/null || true
    cp -r /tmp/data/fabric-ca-client/* /app/data/fabric-ca-client/ 2>/dev/null || true
    
    echo "Data initialization complete"
fi

# Start your actual application (replace with your command)
exec "$@"