#!/bin/bash

#Script para servidor principal

# Actualizar lista de paquetes
apt update

# Actualizar paquetes instalados
apt upgrade -y

# Instalar servicio ISC-DHCP-SERVER
apt install isc-dhcp-server -y

# Cambiar la configuración de /etc/default/isc-dhcp-server
bash -c 'cat << EOF > /etc/default/isc-shcp-server
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="enp0s3"
INTERFACESv6=""
EOF'

# Cambiar la configuración en /etc/dhcp/dhcpd.conf
sudo bash -c 'cat << EOF > /etc/dhcp/dhcpd.conf
#  pool {
#    deny members of "foo";
#    range 10.0.29.10 10.0.29.230;
#  }
#}

authoritative;
failover peer "FAILOVER" {
        primary;
        address 172.26.2.101;
        port 647;
        peer address 172.26.2.102;
        peer port 647;
        max-unacked-updates 10;
        max-response-delay 30;
        load balance max seconds 3;
        mclt 1800;
        split 128;
}
subnet 172.26.0.0 netmask 255.255.0.0 {
        option domain-name-servers 8.8.8.8,8.8.4.4;
        option routers 172.26.0.1;
        option broadcast-address 172.26.255.255;
        option subnet-mask 255.255.0.0;
        pool {
                failover peer "FAILOVER";
                max-lease-time 3600;
                range 172.26.4.101 172.26.4.130;
        }
}
EOF'

# Cambiar la configuración en /etc/network/interfaces
sudo bash -c 'cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface

auto enp0s3
iface enp0s3 inet static
        address 172.26.2.101
        network 172.26.0.0
        netmask 255.255.0.0
        broadcast 172.26.255.255
        gateway 172.26.255.255

EOF'

# Reiniciar servicios de Networking y ISC-DHCP-SERVER

systemctl restart networking
systemctl restart isc-dhcp-server

#FIN
echo "Se han realizado todas las tareas y el servidor ha sido configurado"
