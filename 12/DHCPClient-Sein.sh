echo '
auto eth0
iface eth0 inet dhcp
hwaddress ether ...
  up echo nameserver 192.168.122.1 > /etc/resolv.conf
' >/etc/network/interfaces
