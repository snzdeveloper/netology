
## pip
sudo apt install python3-pip

## venv
sudo apt install python3-venv

### создать окружение с помощью venv в каталоге ~/ans
python3 -m venv ~/ans

### загрузить окружение 
source ~/ans/bin/activate
### выйти
deactivate


## playbook
### Запуск playbook
ansible-playbook -i inventory/test.yml site.yml
### запуск с паролем sudo
ansible-playbook -i inventory/prod.yml ci.yml --extra-vars "ansible_become_pass=qwe"

## inventory
### Структура зависимостей в inventory
ansible-inventory -i inventory/test.yml --graph

### Список всей информации о хостах
ansible-inventory -i inventory/test.yml --list

### Запуск с запросом пароля
ansible-playbook -i inventory/prod.yml ssh.yml -k
ansible-playbook -i inventory/prod.yml clickhouse.yml --extra-vars "proxy_host=46.45.*.* ansible_become_pass=qwe"

## roles
### иницализировать роль (copylite)
ansible-galaxy role init copylite
### скачать роль из requirements.yml в каталог 'roles' 
ansible-galaxy install -r requirements.yml -p roles [ --force ]

## molecule
### утановка 
pip install ansible molecule "molecule-plugins[docker]"


#molecule init scenario --driver-name docker - не работает
 molecule init scenario

### запуск сценария 'ubuntun' с выводом подробной информации '-v'
molecule -v test -s ubuntun

### запуск сценария 'ubuntun' без удаления контейнера '--destroy never'
molecule -v test -s ubuntun --destroy never


## module  
### запуск локально (copylite.py в ./library)
```sh
ANSIBLE_LIBRARY=./library ansible -m copylite.py -a "dest='/tmp/ttta.txt' content='test qwerty 777'" localhost
```

## collections
### сформировать .tar.gz с коллекцией
```sh
cd ansible-collection/snzdeveloper  
ansible-galaxy collection build  
```
### установить коллекцию из .tar.gz
```sh
ansible-galaxy collection install snzdeveloper-base-1.0.0.tar.gz  
ansible-galaxy collection list  
```


## ssh
### подключение через jumphost
ssh -o ProxyCommand="ssh -W %h:%p -q 46.45.0.0 -p 222 -i ~/.ssh/id_ed25519 -l jumpuser" -i ~/.ssh/id_ed25519 -l user 10.1.200.3

### скопировать ключ на jumphost
ssh-copy-id -i /home/vboxuser/.ssh/id_ed25519 -p 222 jumpuser@46.45.0.0

### скопировать ключ на целевой хост через jump host
ssh-copy-id -i /home/vboxuser/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q 46.45.0.0 -p 222 -i /home/vboxuser/.ssh/id_ed25519 -l jumpuser" user@10.1.200.3


### для сборки модулей
sudo apt install build-essential libssl-dev libffi-dev python-dev-is-python3

### tox
#https://stackoverflow.com/questions/76351518/tox-skipped-because-could-not-find-python-interpreter
#https://github.com/pyenv/pyenv?tab=readme-ov-file

######https://www.endpointdev.com/blog/2025/03/testing-ansible-with-molecule/
######https://github.com/antmelekhin/docker-systemd/blob/main/README.md

###### https://stackoverflow.com/questions/78990297/ansible-yum-throwing-future-feature-annotations-is-not-defined
###### ansible-galaxy collection install community.docker --upgrade


###### docker-podman-systemd
######https://habr.com/ru/companies/redhatrussia/articles/468931/

###### debug
######https://stackoverflow.com/questions/73378057/how-to-debug-remote-python-script-in-vs-code
######https://medium.com/@tushe_33516/guide-to-writing-and-debugging-ansible-modules-in-vscode-a-nearly-perfect-setup-ad54024a466a
