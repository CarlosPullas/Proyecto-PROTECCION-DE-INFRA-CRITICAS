# 04 - Verificacion de eventos Windows

## Listar indices Windows

Comando:

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-endpoint-winevent-*?v&s=index'
```

Para que sirve:

Confirma que HELK esta indexando eventos de Winlogbeat.

Resultado esperado:

Indices como:

- `logs-endpoint-winevent-sysmon-*`
- `logs-endpoint-winevent-security-*`
- `logs-endpoint-winevent-powershell-*`

## Ultimos eventos Windows

Comando:

```bash
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-endpoint-winevent-*/_search?pretty' \
  -d '{"size":5,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","host_name","source_name","event_id"]}'
```

Para que sirve:

Muestra documentos recientes de Windows.

Resultado esperado:

Eventos con `host_name`, `source_name` y `event_id`.

## KQL en Kibana

Comando:

```kql
host_name: "carlos"
```

Para que sirve:

Filtra eventos del host Windows observado.

Resultado esperado:

Eventos recientes de Sysmon, Security y PowerShell.
