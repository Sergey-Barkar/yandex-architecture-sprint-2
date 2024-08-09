#!/bin/bash
echo "up containers"
docker compose up -d
echo "preparing mongo_configSrv"
docker compose exec -T mongo_configSrv mongosh --port 27017 <<EOF
rs.initiate({_id : "mongo_configSrv", configsvr: true, members: [{ _id : 0, host : "mongo_configSrv:27017" }]})
EOF
echo "preparing mongo_shard1"
docker compose exec -T mongo_shard1 mongosh --port 27018 <<EOF
rs.initiate({_id : "mongo_shard1", members: [ { _id : 0, host : "mongo_shard1:27018" }]})
EOF
echo "preparing mongo_shard2"
docker compose exec -T mongo_shard2 mongosh --port 27019 <<EOF
rs.initiate({_id : "mongo_shard2", members: [ { _id : 0, host : "mongo_shard2:27019" }]})
EOF
echo "preparing mongo_router"
docker compose exec -T mongo_router mongosh --port 27020 <<EOF
sh.addShard("mongo_shard1/mongo_shard1:27018")
sh.addShard("mongo_shard2/mongo_shard2:27019")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "age": "hashed" })
EOF
echo "inserting data"
docker compose exec -T mongo_router mongosh "mongo_router:27020/somedb" <<EOF
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
echo "success"
sleep 20