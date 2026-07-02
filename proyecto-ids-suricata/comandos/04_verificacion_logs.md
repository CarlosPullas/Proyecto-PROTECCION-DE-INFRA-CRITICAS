# 04 - Verificacion de logs

## Comando

```bash
test -f /var/log/suricata/eve.json && echo existe
```

## Explicacion

Comprueba que exista el archivo principal de eventos de Suricata.

## Resultado esperado

```text
existe
```

## Comando

```bash
wc -l /var/log/suricata/eve.json
sleep 15
wc -l /var/log/suricata/eve.json
```

## Explicacion

Compara la cantidad de eventos antes y despues de esperar unos segundos.

## Resultado esperado

El segundo numero debe ser igual o mayor. En un entorno con trafico debe aumentar.

## Comando

```bash
journalctl -u filebeat --since '10 minutes ago' --no-pager
```

## Explicacion

Muestra eventos recientes del servicio Filebeat.

## Resultado esperado

No deben aparecer errores recurrentes de conexion o lectura.
