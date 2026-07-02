# Proyecto IDS Suricata con HELK

## Objetivo

Este servidor funciona como sensor IDS basado en Suricata. Su objetivo es monitorear trafico de red desde la interfaz `ens33`, generar eventos en formato JSON y enviarlos al SIEM HELK mediante Filebeat hacia Logstash Beats.

## Datos del entorno

| Elemento | Valor |
| --- | --- |
| Servidor IDS | `192.168.1.37` |
| Servidor HELK | `192.168.1.22` |
| Puerto Logstash Beats | `192.168.1.22:5044` |
| Interfaz monitoreada | `ens33` |
| Log principal Suricata | `/var/log/suricata/eve.json` |
| Indice esperado en HELK | `logs-suricata-*` |
| Campo identificador del sensor | `ids.sensor_ip = 192.168.1.37` |

## Que es Suricata

Suricata es un motor IDS/IPS y NSM que inspecciona trafico de red, aplica reglas de deteccion y genera eventos de seguridad. En este servidor se ejecuta como servicio systemd y escribe eventos en `/var/log/suricata/eve.json`.

## Que es Filebeat

Filebeat es un agente ligero de Elastic Beats. En este servidor lee `/var/log/suricata/eve.json`, agrega metadatos del sensor y envia los eventos a Logstash en HELK por `192.168.1.22:5044`.

## Flujo de datos

1. La interfaz `ens33` recibe trafico de red.
2. Suricata inspecciona el trafico y genera eventos.
3. Suricata escribe los eventos en `/var/log/suricata/eve.json`.
4. Filebeat lee `eve.json`.
5. Filebeat agrega campos como `ids.sensor_ip`.
6. Filebeat envia los eventos a Logstash Beats en HELK.
7. HELK indexa los documentos en `logs-suricata-*`.

## Arranque automatico

Los servicios necesarios deben quedar habilitados:

```bash
systemctl is-enabled suricata
systemctl is-enabled filebeat
```

Resultado esperado:

```text
enabled
enabled
```

## Verificacion rapida

```bash
systemctl is-active suricata
systemctl is-active filebeat
ip -br addr show ens33
nc -vz -w 5 192.168.1.22 5044
filebeat test output -c /etc/filebeat/filebeat.yml
```

Resultado esperado:

- Suricata: `active`
- Filebeat: `active`
- `ens33`: `UP` con IP `192.168.1.37`
- Conexion TCP exitosa a `192.168.1.22:5044`
- `filebeat test output`: `talk to server... OK`

## Verificar generacion de eventos

```bash
wc -l /var/log/suricata/eve.json
ping -c 5 192.168.1.22
sleep 15
wc -l /var/log/suricata/eve.json
```

El numero de lineas debe crecer cuando Suricata registra eventos nuevos.

## Generar pruebas

Pruebas simples:

```bash
ping -c 5 192.168.1.22
nc -vz -w 2 192.168.1.22 80
nc -vz -w 2 192.168.1.22 443
nc -vz -w 2 192.168.1.22 5044
```

Estas pruebas generan trafico visible para el sensor.

## Confirmar recepcion en HELK

Desde HELK, consultar Elasticsearch dentro del contenedor:

```bash
docker exec helk-elasticsearch curl -sS 'http://localhost:9200/_cat/indices/logs-suricata-*?h=index,docs.count,store.size&s=index'
docker exec helk-elasticsearch curl -sS 'http://localhost:9200/logs-suricata-*/_count?q=ids.sensor_ip:192.168.1.37'
```

Para ver documentos recientes:

```bash
docker exec helk-elasticsearch curl -sS 'http://localhost:9200/logs-suricata-*/_search' \
  -H 'Content-Type: application/json' \
  -d '{"size":3,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","ids.sensor_ip","event_type","src_ip","dest_ip"],"query":{"term":{"ids.sensor_ip":"192.168.1.37"}}}'
```

El conteo debe aumentar despues de generar trafico nuevo.

## Archivos incluidos

- `configuraciones/`: copias de configuracion y salidas tecnicas.
- `comandos/`: comandos de verificacion explicados.
- `evidencias/`: evidencias recolectadas durante la validacion.
- `scripts/verificar_ids.sh`: script de verificacion operativa.
- `informes/informe_servidor_ids_suricata.md`: informe tecnico del servidor.
