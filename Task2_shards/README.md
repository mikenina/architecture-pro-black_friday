# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

```shell
./scripts/test.sh
```

Вы должны увидеть что-то такое:
```shell
./scripts/test.sh
rs-shard01 [direct: primary] test> switched to db somedb
rs-shard01 [direct: primary] somedb> >>> Count documents on DB shard01:

rs-shard01 [direct: primary] somedb> 1016
rs-shard01 [direct: primary] somedb> rs-shard02 [direct: primary] test> switched to db somedb
rs-shard02 [direct: primary] somedb> >>> Count documents on DB shard02:

rs-shard02 [direct: primary] somedb> 984
rs-shard02 [direct: primary] somedb> [direct: mongos] test> switched to db somedb
[direct: mongos] somedb> >>> Total number of documents:

[direct: mongos] somedb> 2000
[direct: mongos] somedb>
```

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs