echo '
auto eth0
iface eth0 inet dhcp
hwaddress ether 6a:1d:a5:09:89:94
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
' >/etc/network/interfaces
