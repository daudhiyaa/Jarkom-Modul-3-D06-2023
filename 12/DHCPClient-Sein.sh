echo '
auto eth0
iface eth0 inet dhcp
hwaddress ether b2:18:be:a8:d0:d9
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
' >/etc/network/interfaces
