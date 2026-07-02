# 03 - Verificacion de Filebeat

## Comando

```bash
systemctl is-active filebeat
```

## Explicacion

Comprueba si Filebeat esta activo.

## Resultado esperado

```text
active
```

## Comando

```bash
filebeat test config -c /etc/filebeat/filebeat.yml
```

## Explicacion

Valida la sintaxis de la configuracion de Filebeat.

## Resultado esperado

```text
Config OK
```

## Comando

```bash
filebeat test output -c /etc/filebeat/filebeat.yml
```

## Explicacion

Comprueba si Filebeat puede conectarse a Logstash en HELK.

## Resultado esperado

Debe mostrar `talk to server... OK`.

## Comando

```bash
ss -tnp | grep '192.168.1.22:5044'
```

## Explicacion

Verifica si existe una conexion TCP establecida desde Filebeat hacia HELK.

## Resultado esperado

Una linea `ESTAB` asociada al proceso `filebeat`.
