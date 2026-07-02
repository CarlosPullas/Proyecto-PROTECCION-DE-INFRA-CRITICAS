# 02 - Verificacion de puertos

## Puertos publicados por Docker

Comando:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}'
```

Para que sirve:

Muestra que puertos estan expuestos por cada contenedor.

Resultado esperado:

- `helk-nginx`: `0.0.0.0:443->443/tcp`
- `helk-logstash`: `0.0.0.0:5044->5044/tcp`

## Listeners del sistema

Comando:

```bash
sudo ss -tlnp | grep -E ':(443|5044)\b'
```

Para que sirve:

Confirma que el host escucha en HTTPS y Beats.

Resultado esperado:

```text
0.0.0.0:443
0.0.0.0:5044
```

## Prueba local de puertos

Comando:

```bash
nc -vz -w 3 127.0.0.1 443
nc -vz -w 3 127.0.0.1 5044
nc -vz -w 3 192.168.1.22 5044
```

Para que sirve:

Valida conectividad TCP local hacia Nginx y Logstash.

Resultado esperado:

```text
succeeded
```
