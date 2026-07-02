# 03 - Verificacion de indices

## Salud Elasticsearch

Comando:

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cluster/health?pretty'
```

Para que sirve:

Muestra el estado del cluster.

Resultado esperado:

En un nodo unico puede ser `yellow` si hay replicas sin asignar. Debe tener shards primarios activos y no estar `red`.

## Todos los indices

Comando:

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices?v&s=index'
```

Para que sirve:

Lista todos los indices existentes.

Resultado esperado:

Deben aparecer indices `.kibana`, `.monitoring-*`, `logs-endpoint-winevent-*` y `logs-suricata-*`.

## Indices de eventos

Comando:

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-suricata-*,logs-endpoint-winevent-*?v&s=index'
```

Para que sirve:

Filtra indices relevantes para Windows y Suricata.

Resultado esperado:

Indices `green` con `docs.count` mayor que cero.
