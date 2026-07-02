# 01 - Verificacion de servicios

## Comando

```bash
systemctl is-active suricata
systemctl is-active filebeat
```

## Explicacion

Valida si los servicios principales del sensor IDS estan ejecutandose.

## Resultado esperado

```text
active
active
```

## Comando

```bash
systemctl status suricata --no-pager --lines=10
systemctl status filebeat --no-pager --lines=10
```

## Explicacion

Muestra el estado detallado de cada servicio, PID, tiempo activo y ultimos mensajes.

## Resultado esperado

Ambos servicios deben aparecer como `active (running)`.
