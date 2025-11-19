#!/bin/bash
set -e

mongod --configsvr --replSet configRepl --port 27019 --bind_ip_all &
MONGOD_PID=$!

sleep 5

echo ">>> Initializing config server RS (idempotent)"
mongosh --port 27019 <<EOF
try {
  rs.initiate({
    _id: "configRepl",
    configsvr: true,
    members: [{ _id: 0, host: "configsvr:27019" }]
  })
} catch(e) { print("Already initialized") }
EOF

wait $MONGOD_PID
