echo '
# auto eth0
# iface eth0 inet static
# 	address 192.194.4.4
# 	netmask 255.255.255.0
# 	gateway 192.194.4.0
# 	up echo nameserver 192.168.122.1 > /etc/resolv.conf

auto eth0
iface eth0 inet dhcp
  up echo nameserver 192.168.122.1  > /etc/resolv.conf
' >/etc/network/interfaces
