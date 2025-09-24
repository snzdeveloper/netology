# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
    >    
2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
    > где взять подготовленное окружение?   
    > как подготовить своё?   

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.  

    *** сначала такие ошибки   

```sh
vboxuser@ubuntu:~/netology.git/ansible/08-ansible-01-base_02.25/playbook$ ansible-playbook -i inventory/prod.yml site.yml -vvv
ansible-playbook [core 2.18.8]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/vboxuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/vboxuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.12.3 (main, Aug 14 2025, 17:47:21) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
Using /etc/ansible/ansible.cfg as config file
host_list declined parsing /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml as it did not pass its verify_file() method
Parsed /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml inventory source with yaml plugin
Skipping callback 'default', as we already have a stdout callback.
Skipping callback 'minimal', as we already have a stdout callback.
Skipping callback 'oneline', as we already have a stdout callback.

PLAYBOOK: site.yml *********************************************************************************************************************************************************************************************************
2 plays in site.yml
[WARNING]: Could not match supplied host pattern, ignoring: inside

PLAY [Print os facts] ******************************************************************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Print deb facts] *****************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************
task path: /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/site.yml:11
redirecting (type: connection) ansible.builtin.docker to community.docker.docker
<ubuntu> ESTABLISH DOCKER CONNECTION FOR USER: root
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', "/bin/sh -c 'echo ~ && sleep 0'"]
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', '/bin/sh -c \'echo "`pwd`" && sleep 0\'']
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', '/bin/sh -c \'( umask 77 && mkdir -p "` echo ~/.ansible/tmp `"&& mkdir "` echo ~/.ansible/tmp/ansible-tmp-1758730491.338512-1747-71934623348518 `" && echo ansible-tmp-1758730491.338512-1747-71934623348518="` echo ~/.ansible/tmp/ansible-tmp-1758730491.338512-1747-71934623348518 `" ) && sleep 0\'']
fatal: [ubuntu]: UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to create temporary directory. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\", for more error information use -vvv. Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp `\"&& mkdir \"` echo ~/.ansible/tmp/ansible-tmp-1758730491.338512-1747-71934623348518 `\" && echo ansible-tmp-1758730491.338512-1747-71934623348518=\"` echo ~/.ansible/tmp/ansible-tmp-1758730491.338512-1747-71934623348518 `\" ), exited with result 1",
    "unreachable": true
}

PLAY RECAP *****************************************************************************************************************************************************************************************************************
ubuntu                     : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0  

```
 
    *** если поменять remote_tmp в настройках ansible, то такие ошибки   

```sh
 vboxuser@ubuntu:~/netology.git/ansible/08-ansible-01-base_02.25/playbook$ ansible-playbook -i inventory/prod.yml site.yml -vvv
ansible-playbook [core 2.18.8]
  config file = /home/vboxuser/.ansible.cfg
  configured module search path = ['/home/vboxuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/vboxuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.12.3 (main, Aug 14 2025, 17:47:21) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
Using /home/vboxuser/.ansible.cfg as config file
host_list declined parsing /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml as it did not pass its verify_file() method
script declined parsing /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml as it did not pass its verify_file() method
Parsed /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml inventory source with yaml plugin
Skipping callback 'default', as we already have a stdout callback.
Skipping callback 'minimal', as we already have a stdout callback.
Skipping callback 'oneline', as we already have a stdout callback.

PLAYBOOK: site.yml 
****************************************************************************************************************************************************************************
2 plays in site.yml
[WARNING]: Could not match supplied host pattern, ignoring: inside

PLAY [Print os facts] 
****************************************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Print deb facts] 
****************************************************************************************************************************************************************************

TASK [Gathering Facts] 
****************************************************************************************************************************************************************************
task path: /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/site.yml:11
redirecting (type: connection) ansible.builtin.docker to community.docker.docker
[WARNING]: unable to retrieve default user from docker container:   Error: No such object: ubuntu
<ubuntu> ESTABLISH DOCKER CONNECTION FOR USER: ?
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', '/bin/sh -c \'( umask 77 && mkdir -p "` echo /tmp `"&& mkdir "` echo /tmp/ansible-tmp-1758693619.0016677-2275-116500126468422 `" && echo ansible-tmp-1758693619.0016677-2275-116500126468422="` echo /tmp/ansible-tmp-1758693619.0016677-2275-116500126468422 `" ) && sleep 0\'']                                                                          
fatal: [ubuntu]: UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to create temporary directory. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\", for more error information use -vvv. Failed command was: ( umask 77 && mkdir -p \"` echo /tmp `\"&& mkdir \"` echo /tmp/ansible-tmp-1758693619.0016677-2275-116500126468422 `\" && echo ansible-tmp-1758693619.0016677-2275-116500126468422=\"` echo /tmp/ansible-tmp-1758693619.0016677-2275-116500126468422 `\" ), exited with result 1",
    "unreachable": true
}

PLAY RECAP ****************************************************************************************************************************************************************************
ubuntu                     : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0  
 ```

    *** если запустить в docker образ ubuntu, то такие ошибки  

 ```sh
 vboxuser@ubuntu:~/netology.git/ansible/08-ansible-01-base_02.25/playbook$ ansible-playbook -i inventory/prod.yml site.yml -vvv
ansible-playbook [core 2.18.8]
  config file = /home/vboxuser/.ansible.cfg
  configured module search path = ['/home/vboxuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/vboxuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.12.3 (main, Aug 14 2025, 17:47:21) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
Using /home/vboxuser/.ansible.cfg as config file
host_list declined parsing /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml as it did not pass its verify_file() method
script declined parsing /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml as it did not pass its verify_file() method
Parsed /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/inventory/prod.yml inventory source with yaml plugin
Skipping callback 'default', as we already have a stdout callback.
Skipping callback 'minimal', as we already have a stdout callback.
Skipping callback 'oneline', as we already have a stdout callback.

PLAYBOOK: site.yml 
****************************************************************************************************************************************************************************
2 plays in site.yml
[WARNING]: Could not match supplied host pattern, ignoring: inside

PLAY [Print os facts] 
****************************************************************************************************************************************************************************
skipping: no hosts matched

PLAY [Print deb facts] 
****************************************************************************************************************************************************************************

TASK [Gathering Facts] 
****************************************************************************************************************************************************************************
task path: /mnt/share/netology.git/ansible/08-ansible-01-base_02.25/playbook/site.yml:11
redirecting (type: connection) ansible.builtin.docker to community.docker.docker
<ubuntu> ESTABLISH DOCKER CONNECTION FOR USER: root
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', '/bin/sh -c \'( umask 77 && mkdir -p "` echo /tmp `"&& mkdir "` echo /tmp/ansible-tmp-1758695462.777751-4077-248634494975484 `" && echo ansible-tmp-1758695462.777751-4077-248634494975484="` echo /tmp/ansible-tmp-1758695462.777751-4077-248634494975484 `" ) && sleep 0\'']                                                                             
<ubuntu> Attempting python interpreter discovery
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', '/bin/sh -c \'echo PLATFORM; uname; echo FOUND; command -v \'"\'"\'python3.13\'"\'"\'; command -v \'"\'"\'python3.12\'"\'"\'; command -v \'"\'"\'python3.11\'"\'"\'; command -v \'"\'"\'python3.10\'"\'"\'; command -v \'"\'"\'python3.9\'"\'"\'; command -v \'"\'"\'python3.8\'"\'"\'; command -v \'"\'"\'/usr/bin/python3\'"\'"\'; command -v \'"\'"\'python3\'"\'"\'; echo ENDFOUND && sleep 0\'']                                                                                                                                                                          
Using module file /usr/lib/python3/dist-packages/ansible/modules/setup.py
<ubuntu> PUT /home/vboxuser/.ansible/tmp/ansible-local-4073nc4uen17/tmpu1yr7o_a TO /tmp/ansible-tmp-1758695462.777751-4077-248634494975484/AnsiballZ_setup.py
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', "/bin/sh -c 'chmod u+rwx /tmp/ansible-tmp-1758695462.777751-4077-248634494975484/ /tmp/ansible-tmp-1758695462.777751-4077-248634494975484/AnsiballZ_setup.py && sleep 0'"]                                                                                                                                                                                 
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', "/bin/sh -c '/usr/bin/python3 /tmp/ansible-tmp-1758695462.777751-4077-248634494975484/AnsiballZ_setup.py && sleep 0'"]
<ubuntu> EXEC ['/usr/bin/docker', b'exec', b'-i', 'ubuntu', '/bin/sh', '-c', "/bin/sh -c 'rm -f -r /tmp/ansible-tmp-1758695462.777751-4077-248634494975484/ > /dev/null 2>&1 && sleep 0'"]
fatal: [ubuntu]: FAILED! => {
    "ansible_facts": {},
    "changed": false,
    "failed_modules": {
        "ansible.legacy.setup": {
            "ansible_facts": {
                "discovered_interpreter_python": "/usr/bin/python3"
            },
            "failed": true,
            "module_stderr": "/bin/sh: 1: /usr/bin/python3: not found\n",
            "module_stdout": "",
            "msg": "The module failed to execute correctly, you probably need to set the interpreter.\nSee stdout/stderr for the exact error",
            "rc": 127,
            "warnings": [
                "No python interpreters found for host ubuntu (tried ['python3.13', 'python3.12', 'python3.11', 'python3.10', 'python3.9', 'python3.8', '/usr/bin/python3', 'python3'])"
            ]
        }
    },
    "msg": "The following modules failed to execute: ansible.legacy.setup\n"
}

PLAY RECAP ****************************************************************************************************************************************************************************
ubuntu                     : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

 ```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Приложите ссылку на ваше решение в поле «Ссылка на решение» и нажмите «Отправить решение»
---
