# Bastion

## Construire la box

`make build`

## Nettoyer le dépôt

`make clean`

## Playbook Variables

**internal_ip_eth1**: Ip de l'interface protégé
**internal_ip_eth1_0**: Deuxième IP de l'interface
**public_port_rules**: Liste des correspondances entre un port publique et une adresse protégée

```
  - name: Nome de la règle
    port: Port publique
    target_ip: Ip de la machine protégée
    target_port: Port du service de la machine protégée
```

**internal_service_port_rules**: Liste des correspondances entre un port protégé et une adresse protégée

```
  - name: Nome de la règle
    port: Port protégé
    target_ip: Ip de la machine publique
    target_port: Port du service de la machine publique
```

**internal_service_ip_rules**: Liste des correspondances entre une adresse protégé et une adresse publique

```
  - name: Nom de la règle
    ip: Ip protégé du bastion
    target_ip: Ip de la machine publique
    ports: Port autorisé
      - 80
      - 443
```

### Exemple

```
internal_ip_eth1: 1.1.1.254
internal_ip_eth1_0: 1.1.1.253
public_port_rules:
  - name: http
    port: 10000
    target_ip: 1.1.1.9
    target_port: 80
internal_service_port_rules:
  - name: windows active direcory 2019 - No SSL
    port: 5000
    target_ip: Y.Y.Y.Y
    target_port: 389
internal_service_ip_rules:
  - name: name.fr
    ip: Y.Y.Y.Y
    target_ip: X.X.X.X
    ports:
      - 80
      - 443
```