#!/bin/bash
set -e

mongod --shardsvr --replSet rs-shard01 --port 27018 --bind_ip_all &
MONGOD_PID=$!

sleep 5

mongosh --port 27018 <<EOF
try {
  rs.initiate({
    _id: "rs-shard01",
    members: [{ _id: 0, host: "shard01:27018" }]
  })
} catch(e) { print("rs-shard01 already initialized") }
EOF

wait $MONGOD_PID
