# pymongo-api

## Как запустить

```shell
docker compose \
  -f ./sharding-repl-cache/compose.yaml \
  up -d
```

Заполняем mongodb данными

```shell
./sharding-repl-cache/scripts/mongo-init.sh
```

## Как проверить

```shell
./sharding-repl-cache/scripts/test.sh
```

Вы должны увидеть что-то такое:
```shell
./scripts/test.sh
rs-shard01 [direct: secondary] test> switched to db somedb
rs-shard01 [direct: secondary] somedb> >>> Count documents on DB shard01:

rs-shard01 [direct: secondary] somedb> 1016
rs-shard01 [direct: secondary] somedb> >>> Count replica on DB shard01:

rs-shard01 [direct: secondary] somedb> 3
rs-shard01 [direct: secondary] somedb> rs-shard02 [direct: secondary] test> switched to db somedb
rs-shard02 [direct: secondary] somedb> >>> Count documents on DB shard02:

rs-shard02 [direct: secondary] somedb> 984
rs-shard02 [direct: secondary] somedb> >>> Count replica on DB shard01:

rs-shard02 [direct: secondary] somedb> 3
rs-shard02 [direct: secondary] somedb> [direct: mongos] test> switched to db somedb
[direct: mongos] somedb> >>> Total number of documents:

[direct: mongos] somedb> 2000

 === Проверка FastAPI Cache ===
Запрос #1: 1.030966174 секунд
Запрос #2: .009197275 секунд
Запрос #3: .011141598 секунд
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