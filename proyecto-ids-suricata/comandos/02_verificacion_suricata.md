# 02 - Verificacion de Suricata

## Comando

```bash
systemctl is-active suricata
```

## Explicacion

Comprueba si Suricata esta activo.

## Resultado esperado

```text
active
```

## Comando

```bash
suricata --build-info
```

## Explicacion

Muestra la version, capacidades de compilacion y caracteristicas habilitadas de Suricata.

## Resultado esperado

Salida con la version de Suricata y opciones de compilacion.

## Comando

```bash
tail -n 20 /var/log/suricata/eve.json
```

## Explicacion

Revisa eventos recientes generados por Suricata.

## Resultado esperado

Lineas JSON con campos como `timestamp`, `event_type`, `src_ip` y `dest_ip`.
