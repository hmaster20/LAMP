
sudo apt-get install lamp-server^

mysql -u root -p
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;
FLUSH PRIVILEGES;
exit

cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

sudo apt-get update
sudo apt-get install php5-gd libssh2-php

cd ~/wordpress
cp wp-config-sample.php wp-config.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/
nano wp-config.php

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpressuser');

/** MySQL database password */
define('DB_PASSWORD', 'password');

define('AUTH_KEY',         'C_w%-0]ImnNb(Jh^|zv)xRu.--HL{%=+m,uf!+;yC;h&epqQfU>tt|U1G{BB!+Aq');
define('SECURE_AUTH_KEY',  'M(+<*kYSR/z6RKs!o[R(]~VOG_h$~msU512s:/5,mY@T2S|g!qQ#B[K|M;Kh=12S');
define('LOGGED_IN_KEY',    'm}i&Q,TyzF:+|[QmBQ$JX>H>K ??e{{}|CX##xSj,/PQn;_(#5|P9`>:A;m(HAr8');
define('NONCE_KEY',        'iZIF<`2P2G=Izfuqa{{?ubxcro3k=ypP}+e3R4/aS>A&Dz~)J{m.Y%`#-3mhy3Lg');
define('AUTH_SALT',        'X&H}`-yn{6w%7&&gzT%dp`b3w%=sd|a?)J.B?/{D=j|]Ko#=_WJ<UEhn_SUV%-=k');
define('SECURE_AUTH_SALT', 'u|aer|lbm?Nb|k3xyFi5<J-~T9a3V4q8Of(#*U*KD{s<V.|%!#[:=Cw2owfIsqn?');
define('LOGGED_IN_SALT',   '|7<3MAFnHo+^-gj>:?!+=tu3lyP#a{g@:ZVZT~K!^)|u`7-x~]diNm~&Op4q#3Bv');
define('NONCE_SALT',       't](8u9qfR(!E|umR*$$d$QBq/UODi!C$IU/@jz3hM1}n!z+5{J_oh/!-6V`_S~CX');


sudo rsync -avP ~/wordpress/ /var/www/html/
cd /var/www/html
sudo chown -R hmaster:www-data *
mkdir /var/www/html/wp-content/uploads
sudo chown -R :www-data /var/www/html/wp-content/uploads

echo '<?php phpinfo(); ?>' | sudo tee /var/www/html/info.php
# Visit in a web browser:
# http://your_server_IP_address/info.php

sudo nano /etc/apache2/sites-available/000-default.conf

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ServerName 192.168.1.59
    <Directory /var/www/html/>
        AllowOverride All
    </Directory>

sudo a2enmod rewrite
touch /var/www/html/.htaccess
sudo chown :www-data /var/www/html/.htaccess
chmod 664 /var/www/html/.htaccess
chmod 644 /var/www/html/.htaccess

On the left-hand side, under the Settings menu, you can select Permalinks:
Default
When you have made your selection, click "Save Changes" to generate the rewrite rules.

sudo nano /etc/apache2/mods-enabled/dir.conf
Change:
 DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
To:
  DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
sudo service apache2 restart


sudo apt-get install phpmyadmin apache2-utils
Select Apache2 for the server
Choose YES when asked about whether to Configure the database for phpmyadmin with dbconfig-common
Enter your MySQL password when prompted
Enter the password that you want to use to log into phpmyadmin


sudo nano /etc/apache2/apache2.conf
# Add the phpmyadmin config to the file.
Include /etc/phpmyadmin/apache.conf

sudo service apache2 restart

# Visit in a web browser:
# http://your_server_IP_address/phpmyadmin


 sudo find / -name "php.ini"
sudo nano /etc/php5/apache2/php.ini

max_execution_time = 300
upload_max_filesize = 500M
memory_limit = 256M
post_max_size = 800M


sudo service apache2 restart


# Run in console phpmyadmin
# old url=http://it-enginer.ru  new Url=http://192.168.1.59

UPDATE n_options SET option_value = replace(option_value, 'http://it-enginer.ru', 'http://192.168.1.59') WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE n_posts SET post_content = replace(post_content, 'http://it-enginer.ru', 'http://192.168.1.59');
UPDATE n_postmeta SET meta_value = replace(meta_value,'http://it-enginer.ru','http://192.168.1.59');
UPDATE n_usermeta SET meta_value = replace(meta_value, 'http://it-enginer.ru','http://192.168.1.59');
UPDATE n_links SET link_url = replace(link_url, 'http://it-enginer.ru','http://192.168.1.59');
UPDATE n_comments SET comment_content = replace(comment_content , 'http://it-enginer.ru','http://192.168.1.59');

# Настройка ЧПУ
# использвоание вместо ссылок вида  site.ru/?page_id=xxxx    ссылки вида site.ru/page

sudo nano /etc/phpmyadmin/apache.conf

<Directory /usr/share/phpmyadmin>
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
  

cd /var/www/html/
sudo nano .htaccess

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress


sudo service apache2 restart

