#!/bin/bash

docker compose exec -T shard01-b mongosh --port 27018 --quiet <<'EOF'
use somedb
print(">>> Count documents on DB shard01:")
db.helloDoc.countDocuments()
print(">>> Count replica on DB shard01:")
rs.status().members.length
EOF

docker compose exec -T shard02-c mongosh --port 27017 --quiet <<'EOF'
use somedb
print(">>> Count documents on DB shard02:")
db.helloDoc.countDocuments()
print(">>> Count replica on DB shard01:")
rs.status().members.length
EOF

docker compose exec -T mongos mongosh "mongodb://mongos:27020" --quiet <<'EOF'
use somedb
print(">>> Total number of documents:")
db.helloDoc.countDocuments()
EOF

URL="http://localhost:8080/helloDoc/users"

echo "=== Проверка FastAPI Cache ==="

for i in 1 2 3; do
    START=$(date +%s.%N)
    curl -o /dev/null -s "$URL"
    END=$(date +%s.%N)
    ELAPSED=$(echo "$END - $START" | bc)
    echo "Запрос #$i: $ELAPSED секунд"
done