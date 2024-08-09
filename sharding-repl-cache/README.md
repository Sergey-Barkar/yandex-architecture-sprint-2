# pymongo-api

![Image1](schema.jpg)

## Как запустить

Запускаем mongodb и приложение

```shell
./deploy.sh
```
Ремарка. Файл создан в OS Windows, использует иные символы перехода на новую строку, для иных OS может потребоваться корректировка.

## Как проверить

Для проверки шардирования результата введите команды:
```shell
docker exec -it mongo_shard1_1 mongosh "mongo_shard1_1:27018/somedb"
db.helloDoc.countDocuments()
exit

docker exec -it mongo_shard2_1 mongosh "mongo_shard2_1:27019/somedb"
db.helloDoc.countDocuments()
exit
```

Для проверки репликации результата введите команды:
```shell
docker exec -it mongo_shard1_1 mongosh "mongo_shard1_1:27018/somedb"
db.helloDoc.countDocuments()
exit

docker exec -it mongo_shard1_2 mongosh "mongo_shard1_2:27021/somedb"
db.helloDoc.countDocuments()
exit

docker exec -it mongo_shard1_3 mongosh "mongo_shard1_3:27022/somedb"
db.helloDoc.countDocuments()
exit
```