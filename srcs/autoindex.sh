if [ $1 == 'on' ]
then
    sed -i.tmp 's/autoindex off/autoindex on/' /etc/nginx/sites-available/default
elif [ $1 == 'off' ]
then
    sed -i.tmp 's/autoindex on/autoindex off/' /etc/nginx/sites-available/default
fi
rm -f default.tmp
service nginx restart