#!/bin/zsh
minikube delete
minikube start --vm-driver=virtualbox
minikube addons enable metallb
minikube addons enable dashboard

# Configuring metallb:

kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/jaml_files/metallb.yaml

# Setting up Minikube's Docker:

eval $(minikube docker-env)

# Creating an serviceaccount:

kubectl create serviceaccount thimo
kubectl apply -f srcs/jaml_files/serviceaccount.yaml

# Creating nginx:

docker build -t my_nginx srcs/nginx/
kubectl apply -f srcs/jaml_files/nginx.yaml

# Creating ftps:

docker build -t my_ftps srcs/ftps/
kubectl apply -f srcs/jaml_files/ftps.yaml

# Creating mysql:

docker build -t my_mysql srcs/mysql/
kubectl apply -f srcs/jaml_files/mysql.yaml

# Creating phpmyadmin:

docker build -t my_phpmyadmin srcs/phpmyadmin/
kubectl apply -f srcs/jaml_files/phpmyadmin.yaml

# Creating wordpress:

docker build -t my_wordpress srcs/wordpress/
kubectl apply -f srcs/jaml_files/wordpress.yaml

# Creating influxdb:

docker build -t my_influxdb srcs/influxdb/
kubectl apply -f srcs/jaml_files/influxdb.yaml

# Creating grafana:

docker build -t my_grafana srcs/grafana/
kubectl apply -f srcs/jaml_files/grafana.yaml

# Creating telegraf:

docker build -t my_telegraf srcs/telegraf/
kubectl apply -f srcs/jaml_files/telegraf.yaml
