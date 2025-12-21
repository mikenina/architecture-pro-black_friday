#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T mongos mongosh "mongodb://mongos:27020" <<EOF
use somedb
for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

