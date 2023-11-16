# TERAKHIR2 abis semua setup selesai tpi sebelum testing

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     channel.D06.com. root.channel.D06.com. (
                        2023110101    ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@               IN      NS      channel.D06.com.
@               IN      A       192.194.1.2 ; IP DNS Server
www             IN      CNAME   channel.D06.com.
granz           IN      A       192.194.2.2 ; IP Load Balancer
' >/etc/bind/jarkom/channel.D06.com

service bind9 restart
