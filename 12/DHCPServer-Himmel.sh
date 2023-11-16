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
}

host Lawine {
    hardware ethernet 22:11:20:66:b5:71;
    fixed-address 192.194.3.3;
}
host Linie {
    hardware ethernet fa:fc:36:b0:ec:8d;
    fixed-address 192.194.3.2;
}
host Lugner {
    hardware ethernet 2e:d1:1b:07:c0:d7;
    fixed-address 192.194.3.1;
}

host Richter {
    hardware ethernet 6a:1d:a5:09:89:94;
    fixed-address 192.194.3.69;
}
host Revolte {
    hardware ethernet 92:2d:40:42:e6:2f;
    fixed-address 192.194.3.70;
}
host Stark {
    hardware ethernet 82:92:c9:1e:3d:2f;
    fixed-address 192.194.4.167;
}
host Sein {
    hardware ethernet b2:18:be:a8:d0:d9;
    fixed-address 192.194.4.168;
}
' >/etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
