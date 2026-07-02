# Flujo de datos HELK

```text
Windows Sysmon/Security/PowerShell -> Winlogbeat -> 192.168.1.22:5044
Suricata eve.json -> Filebeat -> 192.168.1.22:5044
Logstash -> Kafka/Elasticsearch -> Kibana
Navegador -> https://192.168.1.22 -> Nginx -> Kibana
```

Indices principales:

- Windows: `logs-endpoint-winevent-*`
- Suricata: `logs-suricata-*`

Campos Suricata importantes:

- IP origen: `src_ip`
- IP destino: `dest_ip`
- Sensor: `ids.sensor_ip`
- Interfaz monitoreada: `ids.monitored_interface`
- Tipo de evento: `event_type`
- Alerta: `alert.signature`
- Protocolo: `proto`
