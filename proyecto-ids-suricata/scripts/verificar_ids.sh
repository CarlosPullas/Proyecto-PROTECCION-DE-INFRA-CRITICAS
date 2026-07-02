#!/usr/bin/env bash
set -u

IDS_IP="192.168.1.37"
HELK_IP="192.168.1.22"
HELK_PORT="5044"
IFACE="ens33"
EVE="/var/log/suricata/eve.json"
FILEBEAT_CONFIG="/etc/filebeat/filebeat.yml"

failures=0

ok() {
  printf '[OK] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1"
  failures=$((failures + 1))
}

if systemctl is-active --quiet suricata; then
  ok "Suricata activo"
else
  fail "Suricata no esta activo"
fi

if systemctl is-active --quiet filebeat; then
  ok "Filebeat activo"
else
  fail "Filebeat no esta activo"
fi

if ip link show "$IFACE" >/dev/null 2>&1 && [ "$(cat "/sys/class/net/$IFACE/operstate" 2>/dev/null)" = "up" ]; then
  ok "$IFACE activa"
else
  fail "$IFACE no esta activa"
fi

if ip -4 addr show "$IFACE" | grep -q "$IDS_IP"; then
  ok "$IFACE tiene IP $IDS_IP"
else
  fail "$IFACE no tiene IP $IDS_IP"
fi

if [ -f "$EVE" ]; then
  before=$(wc -l < "$EVE")
  ping -c 3 "$HELK_IP" >/dev/null 2>&1 || true
  sleep 10
  after=$(wc -l < "$EVE")
  if [ "$after" -gt "$before" ]; then
    ok "$EVE existe y crece ($before -> $after)"
  else
    fail "$EVE existe pero no crecio durante la prueba ($before -> $after)"
  fi
else
  fail "$EVE no existe"
fi

if nc -vz -w 5 "$HELK_IP" "$HELK_PORT" >/dev/null 2>&1; then
  ok "Conexion a $HELK_IP:$HELK_PORT correcta"
else
  fail "No hay conexion a $HELK_IP:$HELK_PORT"
fi

if journalctl -u filebeat --since '10 minutes ago' --no-pager | grep -Eiq 'error|fail|denied|refused|non-zero'; then
  fail "Filebeat tiene errores recientes en journalctl"
else
  ok "Filebeat sin errores recientes relevantes"
fi

if grep -Eq '^[[:space:]]+sensor_ip:[[:space:]]+192\.168\.1\.37$' "$FILEBEAT_CONFIG"; then
  ok "ids.sensor_ip configurado como $IDS_IP"
else
  fail "ids.sensor_ip no esta configurado como $IDS_IP"
fi

if grep -Eq '^[[:space:]]+hosts:[[:space:]]+\[\"192\.168\.1\.22:5044\"\]' "$FILEBEAT_CONFIG"; then
  ok "Filebeat apunta a $HELK_IP:$HELK_PORT"
else
  fail "Filebeat no apunta a $HELK_IP:$HELK_PORT"
fi

if [ "$failures" -eq 0 ]; then
  printf 'Resultado final: IDS operativo\n'
  exit 0
fi

printf 'Resultado final: %s problema(s) detectado(s)\n' "$failures"
exit 1
