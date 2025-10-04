## playbook
# Запуск playbook
ansible-playbook -i inventory/test.yml site.yml
# запуск с паролем sudo
ansible-playbook -i inventory/prod.yml ci.yml --extra-vars "ansible_become_pass=qwe"

## inventory
# Структура зависимостей в inventory
ansible-inventory -i inventory/test.yml --graph

# Список всей информации о хостах
ansible-inventory -i inventory/test.yml --list

# подключение через jumphost
ssh -o ProxyCommand="ssh -W %h:%p -q 46.45.0.0 -p 222 -i ~/.ssh/id_ed25519 -l jumpuser" -i ~/.ssh/id_ed25519 -l user 10.1.200.3

# скопировать ключ на jumphost
ssh-copy-id -i /home/vboxuser/.ssh/id_ed25519 -p 222 jumpuser@46.45.0.0

# скопировать ключ на целевой хост
ssh-copy-id -i /home/vboxuser/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q 46.45.0.0 -p 222 -i /home/vboxuser/.ssh/id_ed25519 -l jumpuser" user@10.1.200.3

ansible-playbook -i inventory/prod.yml ssh.yml -k
ansible-playbook -i inventory/prod.yml clickhouse.yml --extra-vars "proxy_host=46.45.*.* ansible_become_pass=qwe"


## roles
# скачать роль из requirements.yml
ansible-galaxy install -r requirements.yml -p roles [ --force ]
