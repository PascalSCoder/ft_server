echo "Configuring"

echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

wp core install --allow-root --path='/var/www/html/wordpress' --url='/' --title='testert' --admin_user='root' --admin_password="codam" --admin_email='pspijkst@student.codam.nl'

mysql -e "USE wordpress;UPDATE wp_options SET option_value='https://localhost/wordpress' WHERE option_name='siteurl' OR option_name='home';"
