# Arquitectura IDS -> HELK

## Componentes

| Componente | Funcion |
| --- | --- |
| IDS `192.168.1.37` | Sensor de red con Suricata y Filebeat |
| Suricata | Inspecciona trafico en `ens33` y genera `eve.json` |
| Filebeat | Lee `eve.json` y envia eventos a Logstash |
| HELK `192.168.1.22` | Recibe, procesa e indexa eventos |
| Logstash Beats `5044` | Entrada de eventos desde Filebeat |
| Elasticsearch | Almacena documentos en `logs-suricata-*` |

## Flujo

```text
Red bridged
   |
   v
ens33 en IDS (192.168.1.37)
   |
   v
Suricata
   |
   v
/var/log/suricata/eve.json
   |
   v
Filebeat
   |
   v
192.168.1.22:5044
   |
   v
HELK / Logstash / Elasticsearch
   |
   v
logs-suricata-*
```

## Campos relevantes

| Campo | Valor esperado |
| --- | --- |
| `ids.sensor_ip` | `192.168.1.37` |
| `event.module` | `suricata` |
| `service.type` | `suricata` |
| `observer.type` | `ids` |
