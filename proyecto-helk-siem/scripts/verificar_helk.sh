#!/usr/bin/env bash
set -uo pipefail

HELK_CONTAINERS=(
  helk-elasticsearch
  helk-kibana
  helk-logstash
  helk-nginx
  helk-zookeeper
  helk-kafka-broker
  helk-ksql-server
  helk-ksql-cli
  helk-elastalert
)

ok() { printf '[OK] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; }

echo '== Docker =='
if systemctl is-active --quiet docker; then
  ok 'Docker activo'
else
  fail 'Docker no esta activo'
fi

if systemctl is-enabled --quiet docker; then
  ok 'Docker habilitado al arranque'
else
  warn 'Docker no esta habilitado al arranque'
fi

echo
echo '== Contenedores HELK =='
for c in "${HELK_CONTAINERS[@]}"; do
  status="$(docker inspect -f '{{.State.Status}}' "$c" 2>/dev/null || true)"
  restart="$(docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' "$c" 2>/dev/null || true)"
  if [[ "$status" == "running" ]]; then
    ok "$c running restart=$restart"
  else
    fail "$c status=${status:-missing} restart=${restart:-unknown}"
  fi
done

echo
echo '== Puertos =='
if nc -z -w 3 127.0.0.1 443 >/dev/null 2>&1; then
  ok 'Puerto 443 responde'
else
  fail 'Puerto 443 no responde'
fi

if nc -z -w 3 127.0.0.1 5044 >/dev/null 2>&1; then
  ok 'Puerto 5044 responde'
else
  fail 'Puerto 5044 no responde'
fi

echo
echo '== Elasticsearch =='
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cluster/health?pretty' || warn 'No se pudo consultar Elasticsearch'

echo
echo '== Indices Windows =='
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-endpoint-winevent-*?v&s=index' || warn 'No se pudieron consultar indices Windows'

echo
echo '== Indices Suricata =='
docker exec helk-elasticsearch curl -s 'http://localhost:9200/_cat/indices/logs-suricata-*?v&s=index' || warn 'No se pudieron consultar indices Suricata'

echo
echo '== Ultimos documentos Windows =='
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-endpoint-winevent-*/_search?pretty' \
  -d '{"size":3,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","host_name","source_name","event_id"]}' || warn 'No se pudieron consultar eventos Windows'

echo
echo '== Ultimos documentos Suricata =='
docker exec helk-elasticsearch curl -s -H 'Content-Type: application/json' \
  'http://localhost:9200/logs-suricata-*/_search?pretty' \
  -d '{"size":3,"sort":[{"@timestamp":{"order":"desc"}}],"_source":["@timestamp","event.module","event_type","src_ip","dest_ip","proto","alert.signature","ids.sensor_ip"]}' || warn 'No se pudieron consultar eventos Suricata'
