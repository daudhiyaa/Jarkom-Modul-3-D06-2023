echo '
# nameserver 192.168.122.1
nameserver 192.194.1.2 ; IP DNS Server
' >/etc/resolv.conf

apt-get update
apt-get install dnsutils -y

printf '\n'
host -t A riegel.canyon.D06.com
printf '\n'
host -t PTR 192.194.1.2
printf '\n'
ping -c 5 riegel.canyon.D06.com
printf '\n'
ping -c 5 canyon.D06.com
printf '\n'

host -t A granz.channel.D06.com
printf '\n'
ping -c 5 granz.channel.D06.com
printf '\n'
ping -c 5 channel.D06.com
printf '\n'
