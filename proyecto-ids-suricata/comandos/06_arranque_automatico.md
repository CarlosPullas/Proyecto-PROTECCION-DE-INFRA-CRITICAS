# 06 - Arranque automatico

## Comando

```bash
systemctl is-enabled suricata
systemctl is-enabled filebeat
```

## Explicacion

Verifica si Suricata y Filebeat estan habilitados para iniciar automaticamente al arrancar el servidor.

## Resultado esperado

```text
enabled
enabled
```

## Comando

```bash
systemctl enable suricata
systemctl enable filebeat
```

## Explicacion

Habilita el arranque automatico si alguno aparece como `disabled`.

## Resultado esperado

El servicio queda enlazado a systemd y `systemctl is-enabled` devuelve `enabled`.

## Comando

```bash
systemctl status NetworkManager --no-pager --lines=5
```

## Explicacion

Comprueba que el servicio de red este disponible al inicio si el sistema usa NetworkManager.

## Resultado esperado

El servicio de red debe estar activo o el sistema debe tener otra unidad de red equivalente funcionando.
