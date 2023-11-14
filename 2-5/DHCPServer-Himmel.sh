# CONFIGURE DULU TIAP DHCP CLIENT dari static ke dhcp

apt update
apt install isc-dhcp-server -y

nano /etc/default/isc-dhcp-server
# INTERFACES="eth0"

# config dhcp-server di /etc/dhcp/dhcpd.conf
echo '
subnet 192.194.1.0 netmask 255.255.255.0 {
}

subnet 192.194.2.0 netmask 255.255.255.0 {
}

subnet 192.194.3.0 netmask 255.255.255.0 {
    range 192.194.3.16 192.194.3.32;
    range 192.194.3.64 192.194.3.80;
    option routers 192.194.3.0;
    option broadcast-address 192.194.3.255;
    option domain-name-servers 192.194.1.2; # IP DNS Server
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 192.194.4.0 netmask 255.255.255.0 {
    range 192.194.4.12 192.194.4.20;
    range 192.194.4.160 192.194.4.168;
    option routers 192.194.4.0;
    option broadcast-address 192.194.4.255;
    option domain-name-servers 192.194.1.2; # IP DNS Server
    default-lease-time 720;
    max-lease-time 5760;
}' >>/etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
printf '\n'
service isc-dhcp-server status
