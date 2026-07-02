# 06 - Arranque automatico

## Docker habilitado

Comando:

```bash
sudo systemctl enable docker
```

Para que sirve:

Habilita Docker al iniciar el sistema.

Resultado esperado:

Docker queda `enabled`. En este servidor ya fue verificado como `enabled`.

## Verificar Docker

Comando:

```bash
systemctl is-enabled docker
systemctl is-active docker
```

Para que sirve:

Confirma habilitacion y estado actual.

Resultado esperado:

```text
enabled
active
```

## Verificar restart policy

Comando:

```bash
docker inspect helk-elasticsearch helk-kibana helk-logstash helk-nginx helk-zookeeper helk-kafka-broker helk-ksql-server helk-ksql-cli helk-elastalert --format '{{.Name}} restart={{.HostConfig.RestartPolicy.Name}}'
```

Para que sirve:

Confirma que los contenedores HELK vuelven a levantar tras reinicio.

Resultado esperado:

```text
restart=always
```

## Corregir restart policy si hiciera falta

Comando:

```bash
docker update --restart always helk-elasticsearch helk-kibana helk-logstash helk-nginx helk-zookeeper helk-kafka-broker helk-ksql-server helk-ksql-cli helk-elastalert
```

Para que sirve:

Aplica politica de reinicio automatica a los contenedores HELK.

Resultado esperado:

Cada contenedor queda con `restart=always`.

Nota:

No fue necesario ejecutar esta correccion porque todos los contenedores ya tenian `restart=always`.
