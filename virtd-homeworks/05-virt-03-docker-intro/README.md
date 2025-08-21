
# Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose»

## Задача 1

https://hub.docker.com/repository/docker/snzdeveloper/custom-nginx/general

## Задача 2

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled2.jpg" width="100%"/>

## Задача 3
3.3. nginx в контейнере запущен в интерактивном режиме, а Ctrl+C посылает сигнал останова в стандартный поток ввода.  

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled3.1.jpg" width="100%"/>
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled3.2.jpg" width="100%"/>
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled3.3.jpg" width="100%"/>

## Задача 4

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled4.jpg" width="100%"/>


## Задача 5

Запущен compose.yaml, потому что docker compose в первую очередь ищет файл с таким именем:  
vboxuser@ubuntu:~/centos-deb$ docker compose up -d  
WARN[0000] Found multiple config files with supported names: /home/vboxuser/centos-deb/compose.yaml, /home/vboxuser/centos-deb/docker-compose.yaml  
WARN[0000] Using /home/vboxuser/centos-deb/compose.yaml  

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled5.6.jpg" width="100%"/>

7. docker compose нашёл работающий контейнер ([centos-deb-portainer-1]) в данном проекте, который не описан в compose, так как файл с его описанием был только что удлён.  
WARN[0000] Found orphan containers ([centos-deb-portainer-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.  

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/virtd-homeworks/05-virt-03-docker-intro/Untitled5.jpg" width="100%"/>

