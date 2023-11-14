apt update
apt install isc-dhcp-relay -y

# lalu config relay pada /etc/default/isc-dhcp-relay
echo '
SERVERS="192.194.1.1" # IP DHCP server
INTERFACES="eth0 eth1 eth2 eth3 eth4"
' >/etc/default/isc-dhcp-relay

# config pada /etc/sysctl.conf juga untuk enable ip4 forwarding (uncomment syntax forwarding)
net.ipv4.ip_forward=1

service isc-dhcp-relay start
