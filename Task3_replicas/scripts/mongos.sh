#!/bin/bash
set -e

echo "Starting mongos..."
mongos --configdb ${CONFIG_RS}/${CONFIG_MEMBERS} --port $MONGOS_PORT --bind_ip_all &
MONGOS_PID=$!

# wait mongos
until mongosh "mongodb://localhost:$MONGOS_PORT" --eval "db.adminCommand('ping')" &>/dev/null; do
  echo "Waiting for mongos..."
  sleep 2
done

# wait for shard primaries to be up (simple loop checking RS connect)
echo "Waiting for shard primaries to accept connections..."
for MEMBER in $(echo "$SHARD1_MEMBERS" | tr ',' ' '); do
  HOST=$(echo $MEMBER | cut -d: -f1)
  PORTCHK=$(echo $MEMBER | cut -d: -f2)
  until mongosh "mongodb://$HOST:$PORTCHK" --eval "db.adminCommand('ping')" &>/dev/null; do
    echo "Waiting for $HOST:$PORTCHK ..."
    sleep 2
  done
done

mongosh "mongodb://localhost:$MONGOS_PORT" <<EOF
try { sh.addShard("$SHARD1_RS/$SHARD1_MEMBERS") } catch(e) { print("shard1 addShard err:", e) }
try { sh.addShard("$SHARD2_RS/$SHARD2_MEMBERS") } catch(e) { print("shard2 addShard err:", e) }

try { sh.enableSharding("somedb") } catch(e) { print("enableSharding:", e) }
try { sh.shardCollection("somedb.helloDoc", { "name" : "hashed" }) } catch(e) { print("shardCollection:", e) }
EOF

echo "Mongos initialization complete."
wait $MONGOS_PID
