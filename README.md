# <div align="center"><p>Jarkom-Modul-3-D06-2023</p></div>

## Anggota Kelompok

| Nama                               | NRP        |
| ---------------------------------- | ---------- |
| Achmad Khosyi’ Assajjad Ramandanta | 5025211007 |
| Daud Dhiya' Rozaan                 | 5025211021 |

## No 0

Untuk mendaftarkan domain, kita setup `DNS Server` sebagai berikut :

```sh
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
```

Lalu kita lakukan testing di `Client` dengan syntax berikut :

```sh
apt-get update
apt-get install dnsutils -y

echo '
# nameserver 192.168.122.1
nameserver 192.194.1.2 ; IP DNS Server
' >/etc/resolv.conf

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
```

## No 1

Buat Topologi & Konfigurasi masing2 node **(untuk DCP Client masih menggunakan static IP)**

### Aura (Router - DHCP Relay):

```
auto eth0
iface eth0 inet dhcp
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.194.0.0/16

auto eth1
iface eth1 inet static
	address 192.194.1.0
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.194.2.0
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.194.3.0
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.194.4.0
	netmask 255.255.255.0
```

### SWITCH 3

#### Revolte (DHCP Client)

```
auto eth0
iface eth0 inet static
	address 192.194.3.5
	netmask 255.255.255.0
	gateway 192.194.3.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Richter (DHCP Client)

```
auto eth0
iface eth0 inet static
	address 192.194.3.4
	netmask 255.255.255.0
	gateway 192.194.3.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Lawine (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.3.3
	netmask 255.255.255.0
	gateway 192.194.3.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Linie (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.3.2
	netmask 255.255.255.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
	gateway 192.194.3.0
```

#### Lugner (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.3.1
	netmask 255.255.255.0
	gateway 192.194.3.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### SWITCH 2

#### Denken (Database Server)

```
auto eth0
iface eth0 inet static
	address 192.194.2.1
	netmask 255.255.255.0
	gateway 192.194.2.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Eisen (Load Balancer)

```
auto eth0
iface eth0 inet static
	address 192.194.2.2
	netmask 255.255.255.0
	gateway 192.194.2.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### SWITCH 1

#### Himmel (DHCP Server)

```
auto eth0
iface eth0 inet static
	address 192.194.1.1
	netmask 255.255.255.0
	gateway 192.194.1.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Heiter (DNS Server)

```
auto eth0
iface eth0 inet static
	address 192.194.1.2
	netmask 255.255.255.0
	gateway 192.194.1.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

SWITCH 4

#### Sein (DHCP Client)

```
auto eth0
iface eth0 inet static
	address 192.194.4.5
	netmask 255.255.255.0
	gateway 192.194.4.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Stark (DHCP Client)

```
auto eth0
iface eth0 inet static
	address 192.194.4.4
	netmask 255.255.255.0
	gateway 192.194.4.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Frieren (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.4.3
	netmask 255.255.255.0
	gateway 192.194.4.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Flamme (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.4.2
	netmask 255.255.255.0
	gateway 192.194.4.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Fern (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.194.4.1
	netmask 255.255.255.0
	gateway 192.194.4.0
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

## No 2-5

Untuk menyelesaikan soal no 2-5, kita perlu men-setup beberapa node dengan urutan berikut :

1. All DHCP Client

   ```sh
    echo '
    auto eth0
    iface eth0 inet dhcp
      up echo nameserver 192.168.122.1  > /etc/resolv.conf
    ' >/etc/network/interfaces
   ```

   Syntax ini digunakan untuk merubah Static IP menjadi konfigurasi dari DHCP Server nantinya

2. DHCP Server - Himmel

   ```sh
   apt-get update
   apt-get install isc-dhcp-server -y

   echo '
   INTERFACESv4="eth0"
   ' >/etc/default/isc-dhcp-server

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
   }' >/etc/dhcp/dhcpd.conf

   service isc-dhcp-server restart
   printf '\n'
   # rm /var/run/dhcpd.pid
   service isc-dhcp-server status
   printf '\n'
   ```

3. DHCP Relay - Aura

   ```sh
   apt-get update
   apt-get install isc-dhcp-relay -y

   # lalu config relay pada /etc/default/isc-dhcp-relay
   echo '
   SERVERS="192.194.1.1" # IP DHCP server
   INTERFACES="eth1 eth2 eth3 eth4"
   ' >/etc/default/isc-dhcp-relay

   # config pada /etc/sysctl.conf juga untuk enable ip4 forwarding (uncomment syntax forwarding)
   echo '
   net.ipv4.ip_forward=1
   ' >/etc/sysctl.conf

   service isc-dhcp-relay restart
   ```

Lalu untuk testing apakah DHCP sudah benar, coba lakukan stop-start pada setiap DHCP Client. Setelah distart, coba tuliskan command `ip a` pada web console, dan cek apakah IP telah berubah-ubah. Jika sudah berubah-ubah, maka konfigurasi DHCP sudah benar.

**Jawaban Tiap Soal:**

- No 2.

  Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80 (2)

  Jawaban :

  ```
  subnet 192.194.3.0 netmask 255.255.255.0 {
      range 192.194.3.16 192.194.3.32;
      range 192.194.3.64 192.194.3.80;
      ...
  }
  ```

- No 3.

  Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168 (3)

  Jawaban :

  ```
  subnet 192.194.4.0 netmask 255.255.255.0 {
      range 192.194.4.12 192.194.4.20;
      range 192.194.4.160 192.194.4.168;
      ...
  }
  ```

- No 4.

  Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit (5)

  Jawaban :

  ```
  subnet 192.194.3.0 netmask 255.255.255.0 {
    ...
    option domain-name-servers 192.194.1.2; # IP DNS Server
    ...
  }

  subnet 192.194.4.0 netmask 255.255.255.0 {
    ...
    option domain-name-servers 192.194.1.2; # IP DNS Server
    ...
  }
  ```

- No 5.

  Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit (5)

  Jawaban :

  ```
  subnet 192.194.3.0 netmask 255.255.255.0 {
    ...
    default-lease-time 180;
    max-lease-time 5760;
  }

  subnet 192.194.4.0 netmask 255.255.255.0 {
    ...
    default-lease-time 720;
    max-lease-time 5760;
  }
  ```

## No 6

Untuk menyelesaikan soal no 6, kita perlu men-setup beberapa node dengan urutan berikut :

1. All PHP Worker (Ganti dengan `ether` masing2)

   ```sh
   echo '
   auto eth0
   iface eth0 inet dhcp
   hwaddress ether ...
     up echo nameserver 192.168.122.1 > /etc/resolv.conf
   ' >/etc/network/interfaces

   # SETUP
   apt-get update
   apt-get install nginx php php-fpm -y
   apt-get install wget unzip -y

   wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download&authuser=0&confirm=t&uuid=0e499712-8150-42d4-a474-b29dfb026ab6&at=APZUnTVBse4ducwDDntmAkLSWB1_:1699949521984' -O granz.channel.D06.com

   unzip granz.channel.D06.com
   cp -r modul-3 /var/www/
   rm -r modul-3

   echo '
   server {
     listen 80;

     root /var/www/modul-3;

     index index.php index.html index.htm;
     server_name _;

     location / {
       try_files $uri $uri/ /index.php?$query_string;
     }

     # pass PHP scripts to FastCGI server
     location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
     }

     location ~ /\.ht {
       deny all;
     }

     error_log /var/log/nginx/jarkom_error.log;
     access_log /var/log/nginx/jarkom_access.log;
   }
   ' >/etc/nginx/sites-available/jarkom

   ln -s /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled
   rm -r /etc/nginx/sites-enabled/default

   service nginx reload
   service nginx restart

   service php7.3-fpm start
   service php7.3-fpm status
   ```

2. Load Balancer - Eisen

   ```sh
   echo '
   nameserver 192.194.1.2
   nameserver 192.168.122.1
   ' >/etc/resolv.conf

   apt-get update
   apt-get install nginx
   apt-get install wget unzip -y

   wget --no-check-certificate 'https://drive.usercontent.google.com/download?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download&authuser=0&confirm=t&uuid=0e499712-8150-42d4-a474-b29dfb026ab6&at=APZUnTVBse4ducwDDntmAkLSWB1_:1699949521984' -O granz.channel.D06.com

   unzip granz.channel.D06.com

   cp -r modul-3 /var/www/
   rm -r modul-3

   echo '
   upstream myweb  {
     server 192.194.3.1;
     server 192.194.3.2;
     server 192.194.3.3;
   }

   server {
     listen 80;
     server_name granz.channel.D06.com;

     location / {
       proxy_pass http://myweb;
     }
   }
   ' >/etc/nginx/sites-available/lb-jarkom

   ln -s /etc/nginx/sites-available/lb-jarkom /etc/nginx/sites-enabled

   rm -r /etc/nginx/sites-enabled/default

   service nginx reload
   service nginx restart
   ```

3. DHCP Server - Himmel

   Tambahkan konfigurasi untuk masing-masing worker

   ```sh
   echo '
   ...

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
   ' >/etc/dhcp/dhcpd.conf
   service isc-dhcp-server restart
   ```

4. DNS Server

   Arahkan `A Record` ke IP Load Balancer

   ```sh
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
   ```

5. Client

   Testing di Client apakah Load Balancer sudah berjalan. Jika sudah berjalan, maka Host akan berbeda-beda saat domain diakses.

   ```sh
    apt-get update
    apt-get install lynx -y

    lynx granz.channel.D06.com
   ```

## No 7

Testing menggunakan `apache benchmark` dengan 1000 request dan 100 request/second

- DHCP Client (Bebas yang mana)

  ```sh
  apt-get update
  apt-get install lynx htop apache2-utils -y

  ab -n 1000 -c 100 http://granz.channel.D06.com/
  ```

- All PHP Worker

  Cek banyak request yang masuk terhadap masing-masing worker. Jika `jumlah request = 1000/3`, maka Load Balancer sudah melakukan tugasnya dengan benar

  ```sh
  cat /var/log/nginx/jarkom_access.log | grep "GET" | wc -l
  ```

## No 8 & 9

Untuk nomor 8 & 9, bisa cek README berikut :

- [README no 8](https://github.com/daudhiyaa/Jarkom-Modul-3-D06-2023/blob/main/8/README.md)

- [README no 9](https://github.com/daudhiyaa/Jarkom-Modul-3-D06-2023/blob/main/9/README.md)

## No 10

Pertama-tama, setup Load Balancer untuk menambahkan credential

```sh
apt-get update
apt-get install apache2-utils -y
mkdir -p /etc/nginx/rahasisakita
htpasswd -cb /etc/nginx/rahasisakita/.htpasswd netics ajkD06

echo '
upstream myweb  {
  server 192.194.3.1;
  server 192.194.3.2;
  server 192.194.3.3;
}

server {
  listen 80;
  server_name granz.channel.D06.com;

  location / {
    proxy_pass http://myweb;

    auth_basic '\"Administrator\'s Area\"';
    auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;
  }

  location ~ /\.ht {
    deny all;
  }

  error_log /var/log/nginx/lb_error.log;
  access_log /var/log/nginx/lb_access.log;
}
' >/etc/nginx/sites-available/lb-jarkom

service nginx reload
service nginx restart
```

Lalu, lakukan testing di client

```sh
ab -A netics:ajkD06 -n 100 -c 100 http://granz.channel.D06.com/
```

**Result** :

- Menggunakan Password

![Alt text](images/image.png)

- Tanpa Password / Salah Password

![Alt text](images/image-1.png)

## No 11

Setup Load Balancer agar setiap request yang mengandung `/its` akan di proxy passing menuju halaman `https://www.its.ac.id`

```sh
# Di Load Balancer
echo '
upstream myweb  {
  server 192.194.3.1;
  server 192.194.3.2;
  server 192.194.3.3;
}

server {
  listen 80;
  server_name granz.channel.D06.com;

  location / {
    proxy_pass http://myweb;

    auth_basic '\"Administrator\'s Area\"';
    auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;
  }

  location ~* /its {
    proxy_pass https://www.its.ac.id;
  }

  location ~ /\.ht {
    deny all;
  }

  error_log /var/log/nginx/lb_error.log;
  access_log /var/log/nginx/lb_access.log;
}
' >/etc/nginx/sites-available/lb-jarkom

service nginx reload
service nginx restart
```

Testing di Client

```sh
lynx granz.channel.D06.com/its
```

**Result** :

![Alt text](images/image-2.png)

![Alt text](images/image-3.png)

![Alt text](images/image-4.png)

## No 12

Untuk menyelesaikan soal no 12, kita perlu men-setup beberapa node dengan urutan berikut :

1. All DHCP Client Worker (Ganti dengan `ether` masing2)

   Fixed kan addressnya

   ```sh
   echo '
   auto eth0
   iface eth0 inet dhcp
   hwaddress ether ...
     up echo nameserver 192.168.122.1 > /etc/resolv.conf
   ' >/etc/network/interfaces
   ```

2. Load Balancer - Sein

   Setup Load Balancer agar hanya IP tertentu yang diperbolehkan untuk mengakses domain

   ```sh
   echo '
   upstream myweb  {
     server 192.194.3.1;
     server 192.194.3.2;
     server 192.194.3.3;
   }

   server {
     listen 80;
     server_name granz.channel.D06.com;

     location / {
       proxy_pass http://myweb;

       auth_basic '\"Administrator\'s Area\"';
       auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;

       allow 192.194.3.69;
       allow 192.194.3.70;
       allow 192.194.4.167;
       allow 192.194.4.168;
       deny all;
     }

     location ~* /its {
       proxy_pass https://www.its.ac.id;
       allow all;
     }

     location ~ /\.ht {
       deny all;
     }

     error_log /var/log/nginx/lb_error.log;
     access_log /var/log/nginx/lb_access.log;
   }
   ' >/etc/nginx/sites-available/lb-jarkom

   service nginx reload
   service nginx restart
   ```

3. DHCP Server - Himmel

   Berikan konfigurasi untuk masing DHCP Client

   ```sh
   echo '
   ...
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
   ```

4. All PHP Worker

   Restart nginx pada setiap PHP Worker

   ```sh
   service nginx restart
   ```

## No 13

Setup DATABASE - DENKEN

```sh
apt-get update
apt-get install mariadb-server -y
service mysql start

echo '
# The MariaDB configuration file
#
# The MariaDB/MySQL tools read configuration files in the following order:
# 1. "/etc/mysql/mariadb.cnf" (this file) to set global defaults,
# 2. "/etc/mysql/conf.d/*.cnf" to set global options.
# 3. "/etc/mysql/mariadb.conf.d/*.cnf" to set MariaDB-only options.
# 4. "~/.my.cnf" to set user-specific options.
#
# If the same option is defined multiple times, the last one will apply.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.

#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address
' >/etc/mysql/my.cnf

echo '
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]

#
# * Basic Settings
#
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
#port                   = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
#skip-external-locking

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address            = 0.0.0.0

#
# * Fine Tuning
#
#key_buffer_size        = 16M
#max_allowed_packet     = 16M
#thread_stack           = 192K
#thread_cache_size      = 8
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
#myisam_recover_options = BACKUP
#max_connections        = 100
#table_cache            = 64
#thread_concurrency     = 10

#
# * Query Cache Configuration
#
#query_cache_limit      = 1M
query_cache_size        = 16M

#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# As of 5.1 you can enable the log at runtime!
#general_log_file       = /var/log/mysql/mysql.log
#general_log            = 1
#
# Error log - should be very few entries.
#
log_error = /var/log/mysql/error.log
#
# Enable the slow query log to see queries with especially long duration
#slow_query_log_file    = /var/log/mysql/mariadb-slow.log
#long_query_time        = 10
#log_slow_rate_limit    = 1000
#log_slow_verbosity     = query_plan
#log-queries-not-using-indexes
#
# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
#server-id              = 1
#log_bin                = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
#max_binlog_size        = 100M
#binlog_do_db           = include_database_name
#binlog_ignore_db       = exclude_database_name

#
# * Security Features
#
# Read the manual, too, if you want chroot!
#chroot = /var/lib/mysql/
#
# For generating SSL certificates you can use for example the GUI tool "tinyca".
#
#ssl-ca = /etc/mysql/cacert.pem
#ssl-cert = /etc/mysql/server-cert.pem
#ssl-key = /etc/mysql/server-key.pem
#
# Accept only connections using the latest and most secure TLS protocol version.
# ..when MariaDB is compiled with OpenSSL:
#ssl-cipher = TLSv1.2
# ..when MariaDB is compiled with YaSSL (default in Debian):
#ssl = on

#
# * Character sets
#
# MySQL/MariaDB default is Latin1, but in Debian we rather default to the full
# utf8 4-byte character set. See also client.cnf
#
character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

#
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!

#
# * Unix socket authentication plugin is built-in since 10.0.22-6
#
# Needed so the root database user can authenticate without a password but
# only when running as the unix root user.
#
# Also available for other users if required.
# See https://mariadb.com/kb/en/unix_socket-authentication-plugin/

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.3 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don'\''t understand
[mariadb-10.3]
' >/etc/mysql/mariadb.conf.d/50-server.cnf

mysql -u root -p


# CREATE USER 'PrakJarkom3D06'@'%' IDENTIFIED BY 'KelD06';
# CREATE USER 'PrakJarkom3D06'@'localhost' IDENTIFIED BY 'KelD06';
# CREATE DATABASE dbPrakJarkom3D06;
# GRANT ALL PRIVILEGES ON *.* TO 'PrakJarkom3D06'@'%';
# GRANT ALL PRIVILEGES ON *.* TO 'PrakJarkom3D06'@'localhost';
# FLUSH PRIVILEGES;

mysql -u PrakJarkom3D06 -p KelD06
service mysql start
```

Buat DATABASE Berikut

```sql
CREATE USER 'PrakJarkom3D06'@'%' IDENTIFIED BY 'KelD06';
CREATE USER 'PrakJarkom3D06'@'localhost' IDENTIFIED BY 'KelD06';
CREATE DATABASE dbPrakJarkom3D06;
GRANT ALL PRIVILEGES ON *.* TO 'PrakJarkom3D06'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'PrakJarkom3D06'@'localhost';
FLUSH PRIVILEGES;
```

Testing di Laravel Worker

```sh
apt-get update
apt-get install mariadb-client -y
mariadb --host=192.194.2.1 --port=3306 --user=PrakJarkom3D06 --password=KelD06
```

**Result di Database** :

![Alt text](images/image-5.png)

**Result di Worker** :

![Alt text](images/image-6.png)

## No 14
