echo '
auto eth0
iface eth0 inet dhcp
hwaddress ether 92:2d:40:42:e6:2f
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
' >/etc/network/interfaces
