apt-get update
apt-get install lynx htop apache2-utils -y

ab -n 1000 -c 100 http://192.194.2.2/
ab -n 1000 -c 100 http://granz.channel.D06.com/
