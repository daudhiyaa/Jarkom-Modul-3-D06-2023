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
