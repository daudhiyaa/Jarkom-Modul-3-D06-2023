echo '
# auto eth0
# iface eth0 inet static
# 	address 192.194.3.2
# 	netmask 255.255.255.0
# 	gateway 192.194.3.0
# 	up echo nameserver 192.168.122.1 > /etc/resolv.conf

auto eth0
iface eth0 inet dhcp
  hwaddress ether fa:fc:36:b0:ec:8d
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
