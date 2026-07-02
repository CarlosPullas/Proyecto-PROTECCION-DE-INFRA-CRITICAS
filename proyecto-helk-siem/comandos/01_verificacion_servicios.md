# 01 - Verificacion de servicios

## Docker activo

Comando:

```bash
systemctl is-active docker
```

Para que sirve:

Verifica que Docker este ejecutandose.

Resultado esperado:

```text
active
```

## Docker habilitado al arranque

Comando:

```bash
systemctl is-enabled docker
```

Para que sirve:

Confirma que Docker arranca automaticamente al iniciar el servidor.

Resultado esperado:

```text
enabled
```

## Contenedores HELK

Comando:

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
```

Para que sirve:

Lista contenedores en ejecucion, imagenes, estado y puertos publicados.

Resultado esperado:

Todos los contenedores `helk-*` deben aparecer `Up`.

## Politicas de reinicio

Comando:

```bash
docker inspect helk-elasticsearch helk-kibana helk-logstash helk-nginx helk-zookeeper helk-kafka-broker helk-ksql-server helk-ksql-cli helk-elastalert --format '{{.Name}} restart={{.HostConfig.RestartPolicy.Name}} status={{.State.Status}}'
```

Para que sirve:

Verifica que los contenedores levanten tras reinicio.

Resultado esperado:

```text
restart=always
status=running
```
