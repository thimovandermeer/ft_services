#!/bin/zsh
minikube delete
minikube start --vm-driver=virtualbox
minikube addons enable metallb
minikube addons enable dashboard

# Configuring metallb:

kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/metallb.yaml

# Setting up Minikube's Docker:

eval $(minikube docker-env)

# Creating an serviceaccount:

kubectl create serviceaccount thimo
kubectl apply -f srcs/webserver/service-account.yaml

# Creating webserver:

docker build -t my_nginx srcs/webserver/
kubectl apply -f srcs/webserver/nginx.yaml

# # Creating ftps:

# docker build -t my_ftps srcs/ftps/
# kubectl apply -f srcs/ftps.yaml

# # Creating mysql:

# docker build -t my_mysql srcs/mysql/
# kubectl apply -f srcs/mysql.yaml

# # Creating wordpress:

# docker build -t my_wordpress srcs/wordpress/
# kubectl apply -f srcs/wordpress.yaml