# 05 - Pruebas de conectividad con HELK

## Comando

```bash
ping -c 4 192.168.1.22
```

## Explicacion

Verifica conectividad ICMP entre el IDS y HELK.

## Resultado esperado

`0% packet loss`.

## Comando

```bash
nc -vz -w 5 192.168.1.22 5044
```

## Explicacion

Verifica que el puerto Logstash Beats en HELK este accesible.

## Resultado esperado

```text
Connection to 192.168.1.22 5044 port [tcp/*] succeeded!
```

## Comando

```bash
filebeat test output -c /etc/filebeat/filebeat.yml
```

## Explicacion

Prueba la salida configurada en Filebeat.

## Resultado esperado

Debe resolver `192.168.1.22`, conectar al puerto `5044` y mostrar `talk to server... OK`.
