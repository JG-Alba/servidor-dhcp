## Actualización del sistema
Actualizamos el sistema.
- sudo apt-get update
- sudo apt-get upgrade

## Programas requeridos
Instalamos isc-dhcp-server
Sudo apt-get install isc-dhcp-server

## Desactivamos NetworkManager
- systemctl disable NetworkManager
- Systemctl stop NetworkManager

## Configuramos el sistema

1-. Cambiamos el adaptador puente a red interna, todas las maquinas deben estar en red interna.
2-. Editamos el archivo de configuracion /etc/dhcp/dhcpd.conf Metemos dentro de la configuración un 
    failover con un rango de ip y una puerta de enlace igual para cada archivo

![Failover1](/Imagenes/failover1.png)

![Failover2](/Imagenes/failover2.png)

3-. Editamos el archivo de configuración /etc/network/interfaces para añadirle una ip estatica a cada servidor failover.

![Interface1](/Imagenes/interface1.png)

![Interface2](/Imagenes/interface2.png)

4-. Editamos el archivo de configuracion /etc/default/isc-dhcp-server para que use la tarjeta que necesitamos sea la 
    que se use, ponemos esta configuracion en ambos servidores.

![isc](/Imagenes/isc.png)

5-. Editamos el archivo de configuración /etc/resolv.conf para configurar los dns. Le ponemos los dns a 
    nuestra elección, en este caso los de Google.

![dns](/Imagenes/dns.png)

## Comprobación
A partir de aqui ya estan configurados ambos servidores, el principal y failover. Realizaremos comprobaciones.

1-. Levantamos las tarjetas con "ifup 'tarjeta'"

2-. Reseteamos los sistemas
    - systemctl restart networking.service
    - systemctl restart isc-shcp-server.service
    
3-. Realizamos una comprobacion de los servidores para ver si al caerse el principal el failover toma su lugar, 
    esto apagando el servicio. En el failover hacermos un "Journalctl -f" para ver si toma el control. 
    Si actua esta bien configurado

## Maquina cliente
Con esto hecho, realizamos una comprobación en el cliente para ver si recibe la ip dentro del rango de nuestro servidor.
Si lo recibe ya esta configurado el servidor interno.
