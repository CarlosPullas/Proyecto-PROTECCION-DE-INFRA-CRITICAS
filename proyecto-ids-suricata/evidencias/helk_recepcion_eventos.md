# Evidencia de recepcion en HELK

Fecha de verificacion: 2026-07-02 UTC

## Consulta usada

```bash
docker exec helk-elasticsearch curl -sS 'http://localhost:9200/logs-suricata-*/_count?q=ids.sensor_ip:192.168.1.37'
```

## Resultado observado

El conteo de documentos con `ids.sensor_ip:192.168.1.37` crecio durante la prueba:

```text
before: 427
after: 463
```

Indice observado:

```text
logs-suricata-2026.07.02 8161 10.8mb
```

Ejemplos de documentos recientes contenian:

```json
{"ids":{"sensor_ip":"192.168.1.37"}}
```

Conclusion: HELK recibio eventos nuevos del IDS y los indexo en `logs-suricata-*`.
