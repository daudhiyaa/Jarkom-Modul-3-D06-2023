echo '
auto eth0
iface eth0 inet dhcp
hwaddress ether 82:92:c9:1e:3d:2f
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
' >/etc/network/interfaces
