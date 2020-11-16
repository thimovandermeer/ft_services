cd /www

APISERVER=https://kubernetes.default.svc
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt
URL=$(curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/default/services/wordpress/ 2>/dev/null| jq -r '.status | .loadBalancer | .ingress | .[] | .ip')

wp config create --dbname=wordpress --dbuser=mysql --dbpass=harry --dbhost=mysql
wp db create
wp core install --url=${URL}:5050 --title=wordpress --admin_user=thimo --admin_password=harry --admin_email=thvan-de@student.codam.nl --skip-email
wp user create author author@example.com --role=author --user_pass=harry
wp user create subscriber subscriber@example.com --role=subscriber --user_pass=harry

php-fpm7
nginx

while true; do
	sleep 5
	ps | grep nginx | grep master
	if [ $? == 1 ]; then break
	fi
	ps | grep php-fpm | grep master
	if [ $? == 1 ]; then break
	fi
done
