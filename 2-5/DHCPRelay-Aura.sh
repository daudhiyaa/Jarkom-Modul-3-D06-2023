apt-get update
apt-get install isc-dhcp-relay -y

# lalu config relay pada /etc/default/isc-dhcp-relay
echo '
SERVERS="192.194.1.1" # IP DHCP server
INTERFACES="eth1 eth2 eth3 eth4"
' >/etc/default/isc-dhcp-relay

# config pada /etc/sysctl.conf juga untuk enable ip4 forwarding (uncomment syntax forwarding)
echo '
net.ipv4.ip_forward=1
' >>/etc/sysctl.conf

service isc-dhcp-relay restart
