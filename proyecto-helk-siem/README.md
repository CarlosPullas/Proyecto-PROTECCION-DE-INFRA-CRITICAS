# Proyecto HELK SIEM

## Objetivo

Este servidor ejecuta HELK como SIEM central para recibir, procesar y visualizar eventos de seguridad de Windows y Suricata.

## Datos del servidor

- Servidor SIEM: `192.168.1.22`
- Acceso web HELK/Kibana: `https://192.168.1.22`
- Logstash Beats: `192.168.1.22:5044`
- Usuario web: `helk`
- La contrasena no se documenta en este repositorio.

## Funcion del SIEM

HELK centraliza logs de endpoints Windows y del IDS Suricata. Los eventos llegan a Logstash, se procesan por pipelines HELK, se almacenan en Elasticsearch y se visualizan en Kibana.

## Componentes

- Docker Engine
- Elasticsearch 7.6.2
- Kibana 7.6.2
- Logstash 7.6.2.1
- Nginx como proxy HTTPS con Basic Auth
- Kafka Broker
- Zookeeper
- KSQL Server y KSQL CLI
- Elastalert

## Contenedores HELK

- `helk-elasticsearch`
- `helk-kibana`
- `helk-logstash`
- `helk-nginx`
- `helk-zookeeper`
- `helk-kafka-broker`
- `helk-ksql-server`
- `helk-ksql-cli`
- `helk-elastalert`

Todos los contenedores deben tener politica `restart=always` para levantar automaticamente tras reinicio del servidor.

## Puertos utilizados

- `443/tcp`: acceso web HTTPS a HELK/Kibana por Nginx
- `80/tcp`: Nginx HTTP
- `5044/tcp`: Logstash Beats input para Winlogbeat/Filebeat
- `9092/tcp`: Kafka broker
- `8088/tcp`: KSQL Server
- `3515/tcp`, `5514/tcp/udp`, `8515-8516/tcp/udp`, `8531/tcp`: puertos HELK adicionales

## Flujo de datos

1. Windows envia eventos de Sysmon, Security, PowerShell, System y Application mediante Winlogbeat.
2. Suricata escribe `eve.json` y Filebeat lo envia hacia Logstash.
3. Logstash recibe por `5044/tcp`.
4. HELK transforma los eventos y los guarda en Elasticsearch.
5. Kibana visualiza indices `logs-endpoint-winevent-*` y `logs-suricata-*`.

## Acceso a Kibana/HELK

Abrir desde Windows:

```text
https://192.168.1.22
```

El acceso esta protegido por Nginx Basic Auth.

## Verificar que funciona

```bash
docker ps
sudo ss -tlnp | grep -E ':(443|5044)\b'
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cluster/health?pretty'
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-suricata-*,logs-endpoint-winevent-*?v&s=index'
```

Tambien se puede ejecutar:

```bash
~/proyecto-helk-siem/scripts/verificar_helk.sh
```

## Reiniciar servicios

Reiniciar un contenedor especifico:

```bash
docker restart helk-logstash
```

Reiniciar todos los contenedores HELK:

```bash
docker restart helk-elasticsearch helk-kibana helk-logstash helk-nginx helk-zookeeper helk-kafka-broker helk-ksql-server helk-ksql-cli helk-elastalert
```

No reiniciar el servidor completo sin avisar al operador.

## Comprobar eventos de Windows

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-endpoint-winevent-*?v&s=index'
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-endpoint-winevent-*/_search?pretty' \
  -d '{"size":5,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","host_name","source_name","event_id"]}'
```

Indices esperados:

- `logs-endpoint-winevent-sysmon-*`
- `logs-endpoint-winevent-security-*`
- `logs-endpoint-winevent-powershell-*`
- `logs-endpoint-winevent-system-*`
- `logs-endpoint-winevent-application-*`

## Comprobar eventos de Suricata

```bash
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-suricata-*?v&s=index'
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-suricata-*/_search?pretty' \
  -d '{"size":5,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","event.module","event_type","src_ip","dest_ip","proto","alert.signature","ids.sensor_ip"]}'
```

KQL recomendado en Discover:

```kql
event.module: "suricata"
```

Para solo alertas:

```kql
event.module: "suricata" and event_type: "alert"
```

## Carpetas

- `arquitectura/`: notas de arquitectura.
- `configuraciones/`: copias y snapshots no sensibles.
- `comandos/`: comandos operativos explicados.
- `evidencias/`: salidas de validacion.
- `scripts/`: scripts de verificacion.
- `informes/`: informe tecnico del servidor.
