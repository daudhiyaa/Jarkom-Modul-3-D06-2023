apt-get update
apt-get install bind9 -y

echo '
zone "canyon.D06.com" {
    type master;
    file "/etc/bind/jarkom/canyon.D06.com";
};

zone "1.194.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/1.194.192.in-addr.arpa";
};

zone "channel.D06.com" {
    type master;
    file "/etc/bind/jarkom/channel.D06.com";
};' >/etc/bind/named.conf.local

mkdir -p /etc/bind/jarkom

cp /etc/bind/db.local /etc/bind/jarkom/canyon.D06.com
echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     canyon.D06.com. root.canyon.D06.com. (
                        2023110101    ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
@               IN      NS      canyon.D06.com.
@               IN      A       192.194.1.2 ; IP DNS Server
www             IN      CNAME   canyon.D06.com.
riegel          IN      A       192.194.4.1 ; IP Fern Laravel Worker' >/etc/bind/jarkom/canyon.D06.com

cp /etc/bind/db.local /etc/bind/jarkom/1.194.192.in-addr.arpa
echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     canyon.D06.com. root.canyon.D06.com. (
                        2023110101    ; Serial
                        604800        ; Refresh
                        86400         ; Retry
                        2419200       ; Expire
                        604800 )      ; Negative Cache TTL
;
1.194.192.in-addr.arpa. IN  NS      canyon.D06.com.
2                       IN  PTR     canyon.D06.com.' >/etc/bind/jarkom/1.194.192.in-addr.arpa

cp /etc/bind/db.local /etc/bind/jarkom/channel.D06.com
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
granz           IN      A       192.194.3.1 ; IP Lugner PHP Worker' >/etc/bind/jarkom/channel.D06.com

echo 'options {
        directory "/var/cache/bind";

        forwarders {
            192.168.122.1;
        };

        // dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no; # conform to RFC1035
        listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

service bind9 restart
