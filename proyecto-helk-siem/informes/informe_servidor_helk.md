# Informe tecnico del servidor HELK

## Resumen

Servidor HELK operativo en `192.168.1.22`, con acceso web por `https://192.168.1.22` y recepcion Beats en `192.168.1.22:5044`.

## Que se instalo

La plataforma HELK esta desplegada sobre Docker con los siguientes servicios:

- Elasticsearch
- Kibana
- Logstash
- Nginx
- Kafka Broker
- Zookeeper
- KSQL Server
- KSQL CLI
- Elastalert

No se reinstalo HELK durante esta preparacion.

## Que se configuro

Se verifico y dejo documentado:

- Docker activo y habilitado al arranque.
- Contenedores HELK con `restart=always`.
- Nginx publicado en `443/tcp`.
- Logstash publicado en `5044/tcp`.
- Elasticsearch operativo.
- Indices de Windows y Suricata presentes.
- Documentacion tecnica y script de verificacion en `~/proyecto-helk-siem`.

No se cambiaron IPs, no se eliminaron contenedores y no se borro configuracion.

## Que recibe el SIEM

Windows:

- Sysmon
- Security
- PowerShell
- System
- Application

Indices:

- `logs-endpoint-winevent-*`

Suricata:

- Eventos de `eve.json` enviados por Filebeat.

Indices:

- `logs-suricata-*`

## Como se valido

Se ejecutaron verificaciones de:

- `docker ps`
- Politicas `restart=always`
- `systemctl is-enabled docker`
- `systemctl is-active docker`
- Puertos `443` y `5044`
- Salud de Elasticsearch
- Listado de indices
- Muestras de eventos Windows
- Muestras de eventos Suricata

## Pruebas realizadas

Acceso web:

- `https://127.0.0.1` con credenciales devuelve HTTP `302`.

Puertos:

- `127.0.0.1:443` responde.
- `127.0.0.1:5044` responde.
- `192.168.1.22:5044` responde.

Indices:

- `logs-endpoint-winevent-*` tiene documentos.
- `logs-suricata-*` tiene documentos.

Elasticsearch:

- Estado `yellow`, esperado en despliegue de un solo nodo con replicas sin asignar.

## Estado final

El SIEM queda operativo y preparado para levantar automaticamente tras apagado/encendido del servidor, siempre que Docker inicie correctamente.

Advertencia:

`helk-ksql-server` aparece en ejecucion con `restart=always`, pero su endpoint HTTP `8088` no respondio estable durante una prueba puntual. El resto de la cadena principal de ingesta y visualizacion funciona: Logstash, Elasticsearch, Kibana, Nginx, Kafka e indices de eventos.

## Recomendaciones

- Mantener backup externo de `~/proyecto-helk-siem`.
- No guardar contrasenas en repositorios GitHub.
- Revisar periodicamente espacio en disco con `df -h`.
- Revisar crecimiento de indices Elasticsearch.
- Confirmar despues de cada reinicio:

```bash
~/proyecto-helk-siem/scripts/verificar_helk.sh
```

- Si KSQL es necesario para analitica, revisar logs de `helk-ksql-server`.
