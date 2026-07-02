# 05 - Verificacion de eventos Suricata

## Listar indices Suricata

Comando:

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-suricata-*?v&s=index'
```

Para que sirve:

Confirma que HELK esta indexando eventos del IDS.

Resultado esperado:

Indice `logs-suricata-*` con `docs.count` mayor que cero.

## Ultimos eventos Suricata

Comando:

```bash
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-suricata-*/_search?pretty' \
  -d '{"size":5,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","event.module","event_type","src_ip","dest_ip","proto","alert.signature","ids.sensor_ip"]}'
```

Para que sirve:

Muestra eventos recientes del indice Suricata.

Resultado esperado:

Documentos con `event.module: suricata`, `event_type`, `src_ip`, `dest_ip` y `proto`.

## KQL en Kibana

Comando:

```kql
event.module: "suricata"
```

Para que sirve:

Filtra unicamente eventos de Suricata en Discover.

Resultado esperado:

Solo eventos del IDS.

## Solo alertas

Comando:

```kql
event.module: "suricata" and event_type: "alert"
```

Para que sirve:

Muestra unicamente alertas Suricata.

Resultado esperado:

Eventos con `alert.signature`.
