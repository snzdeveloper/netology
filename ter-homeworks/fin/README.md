# Итоговый проект модуля «Облачная инфраструктура. Terraform»  

## Задание 1. Развертывание инфраструктуры в Yandex Cloud.

### Создайте Virtual Private Cloud (VPC).
### Создайте подсети.

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.1.jpg" width="100%"/>

### Создайте виртуальные машины (VM):
Для Web приложения (см. Задания 5 модуля «Виртуализация и контейнеризация») решено было создать две виртуальные машины.  
На одной ВМ - база данных, на другой - собственно web-приложение.  
И база данных и web приложение запускаются внутри docker контейнеров.  

<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.2.1.jpg" width="100%"/>  

Запуск БД в docker контейнере  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.2.2.jpg" width="100%"/>  

Web приложение в docker контейнере запускается с использованием docker compose.  
Файлы для docker compose берутся из git репозитория  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.2.3.jpg" width="100%"/>  

### Настройте группы безопасности (порты 22, 80, 443).  
### Привяжите группу безопасности к VM.  
Поскольку приложению необходимо взаимодействовать с базой данных, то для внутренней сети был открыт порт 3306.  
Так же были открыты порты во внешнюю сеть 8080-8090 для приложения.  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.3.jpg" width="100%"/>  

### Опишите создание БД MySQL в Yandex Cloud.
Как написано выше в yandex cloud создана виртуальная машина с бд.  

### Опишите создание Container Registry.
Для загрузки образа с web приложением создан yandex container registry  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.4.1.jpg" width="100%"/>  
Была предоставлена роль container-registry.images.puller для всех пользователей(даже без аутентификации), чтобы не настраивать аутентификацию в ВМ (https://yandex.cloud/ru/docs/compute/operations/vm-connect/auth-inside-vm#tf_1)  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_1.4.2.jpg" width="100%"/>  
 
## Задание 2. Используя user-data (cloud-init), установите Docker и Docker Compose (см. Задания 5 модуля «Виртуализация и контейнеризация»).  
Для формирования cloud-init создан модуль ./cloud-init  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_2.1.jpg" width="100%"/>  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_2.2.jpg" width="100%"/>  

## Задание 3. Опишите Docker файл (см. Задания 5 «Виртуализация и контейнеризация») c web-приложением и сохраните контейнер в Container Registry.  
<img src="https://raw.githubusercontent.com/snzdeveloper/netology/main/ter-homeworks/fin/Screenshot_3.1.jpg" width="100%"/>  

## Задание 4. Завяжите работу приложения в контейнере на БД в Yandex Cloud.  
Как написано выше в yandex cloud создана виртуальная машина с бд.  

## Задание 5*. Положите пароли от БД в LockBox и настройте интеграцию с Terraform так, чтобы пароль для БД брался из LockBox.  


