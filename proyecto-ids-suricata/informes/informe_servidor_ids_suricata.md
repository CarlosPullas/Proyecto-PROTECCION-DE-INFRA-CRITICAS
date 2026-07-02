# Informe tecnico - Servidor IDS Suricata

## Resumen

El servidor IDS `192.168.1.37` esta preparado para monitorear la interfaz `ens33` con Suricata, escribir eventos en `/var/log/suricata/eve.json` y enviarlos al SIEM HELK `192.168.1.22` mediante Filebeat hacia Logstash Beats en el puerto `5044`.

## Que se instalo

Suricata y Filebeat ya estaban instalados en el sistema. No se reinstalo ningun componente durante esta preparacion.

## Que se configuro

La configuracion operativa relevante es:

- Suricata ejecutandose como servicio systemd.
- Filebeat leyendo `/var/log/suricata/eve.json`.
- Filebeat enviando eventos a `192.168.1.22:5044`.
- Campo `ids.sensor_ip` configurado como `192.168.1.37`.
- Servicios Suricata y Filebeat habilitados para arranque automatico.

## Reglas usadas

Las reglas cargadas dependen de la configuracion local de Suricata y de las fuentes disponibles para `suricata-update`. En `configuraciones/` se incluyen:

- `suricata.yaml`
- `suricata_build_info.txt`
- `suricata_update_list_sources.txt`

Estos archivos permiten auditar motor, capacidades y fuentes de reglas disponibles.

## Interfaz monitoreada

La interfaz monitoreada es:

```text
ens33
```

La IP actual del IDS en esa interfaz es:

```text
192.168.1.37
```

## Envio a HELK

Filebeat usa la salida Logstash:

```yaml
output.logstash:
  hosts: ["192.168.1.22:5044"]
```

El flujo es:

```text
ens33 -> Suricata -> /var/log/suricata/eve.json -> Filebeat -> HELK Logstash 5044 -> logs-suricata-*
```

## Pruebas realizadas

Se verifico:

- `suricata` activo.
- `filebeat` activo.
- `suricata` enabled.
- `filebeat` enabled.
- `ens33` activa.
- `/var/log/suricata/eve.json` existe y crece.
- Conexion TCP a `192.168.1.22:5044`.
- `filebeat test output` con resultado correcto.
- Conexion establecida del proceso Filebeat hacia HELK.
- Recepcion en HELK mediante busqueda en `logs-suricata-*`.

## Estado final

Estado final esperado:

```text
Suricata: active / enabled
Filebeat: active / enabled
IDS: 192.168.1.37
HELK: 192.168.1.22:5044
Indice: logs-suricata-*
ids.sensor_ip: 192.168.1.37
```

## Recomendaciones

- Ejecutar `scripts/verificar_ids.sh` despues de cada reinicio.
- Revisar periodicamente `journalctl -u filebeat` y `journalctl -u suricata`.
- Confirmar crecimiento del indice `logs-suricata-*` desde HELK.
- Mantener respaldos de `/etc/suricata/suricata.yaml` y `/etc/filebeat/filebeat.yml`.
- Documentar cualquier cambio futuro de IP, interfaz o destino HELK.
