#!/bin/bash

docker compose exec -T shard01 mongosh --port 27018 --quiet <<'EOF'
use somedb
print(">>> Count documents on DB shard01:")
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard02 mongosh --port 27017 --quiet <<'EOF'
use somedb
print(">>> Count documents on DB shard02:")
db.helloDoc.countDocuments()
EOF

docker compose exec -T mongos mongosh "mongodb://mongos:27020" --quiet <<'EOF'
use somedb
print(">>> Total number of documents:")
db.helloDoc.countDocuments()
EOF