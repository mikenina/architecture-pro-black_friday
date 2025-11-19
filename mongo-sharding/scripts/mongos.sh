#!/bin/bash
set -e

mongos --configdb configRepl/configsvr:27019 --port 27020 --bind_ip_all &
MONGOS_PID=$!

sleep 5

echo ">>> Adding shards"
mongosh --port 27020 <<EOF
try { sh.addShard("rs-shard01/shard01:27018") } catch(e) { print("Shard01 exists") }
try { sh.addShard("rs-shard02/shard02:27017") } catch(e) { print("Shard02 exists") }

print(">>> Enabling sharding on DB")
try { sh.enableSharding("somedb") } catch(e) { print("Already enabled") }

print(">>> Sharding collection somedb.helloDoc")
try {
  sh.shardCollection("somedb.helloDoc", { "name" : "hashed" })
} catch(e) { print("Collection already sharded / error") }
EOF

wait $MONGOS_PID
