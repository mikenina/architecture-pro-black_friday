#!/bin/bash
set -e

echo "Starting SHARD SERVER NODE: $RS_NAME on port $PORT"

mongod --shardsvr --replSet "$RS_NAME" --port "$PORT" --dbpath /data/db --bind_ip_all &
MONGOD_PID=$!

until mongosh --port "$PORT" --eval "db.adminCommand('ping')" &>/dev/null; do
    sleep 1
done

if [ "$IS_PRIMARY_NODE" = "true" ]; then
  echo "Attempting RS initiation for $RS_NAME"

  mongosh --port "$PORT" <<EOF
let status;
try {
  status = rs.status();
} catch (e) {
  // NotYetInitialized: code 94
  status = { code: 94 };
}

if (status.code === 94) {
  print("Replica set $RS_NAME not initialized. Initializing...");
  rs.initiate({
    _id: "$RS_NAME",
    members: [
      { _id: 0, host: "$HOST_A:$PORT" },
      { _id: 1, host: "$HOST_B:$PORT" },
      { _id: 2, host: "$HOST_C:$PORT" }
    ]
  });
} else {
  print("Replica set $RS_NAME already initialized.");
}
EOF
fi

wait $MONGOD_PID
