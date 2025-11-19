#!/bin/bash
set -e

mongod --shardsvr --replSet rs-shard02 --port 27017 --bind_ip_all &
MONGOD_PID=$!

sleep 5

mongosh --port 27017 <<EOF
try {
  rs.initiate({
    _id: "rs-shard02",
    members: [{ _id: 0, host: "shard02:27017" }]
  })
} catch(e) { print("rs-shard02 already initialized") }
EOF

wait $MONGOD_PID
