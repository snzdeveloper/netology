# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.
```sh

(pip) vboxuser@ubuntu:~/netology.git/ansible/08-ansible-05-testing/roles/clickhouse$ molecule -vvv test -s ubuntu_xenial
DEBUG    unknown ➜ config: provisioner.playbooks found in /mnt/share/netology.git/ansible/08-ansible-05-testing/roles/clickhouse/molecule/ubuntu_xenial/molecule.yml, this can be defined in ansible.playbooks
DEBUG    unknown ➜ config: provisioner.playbooks found in /mnt/share/netology.git/ansible/08-ansible-05-testing/roles/clickhouse/molecule/ubuntu_xenial/molecule.yml, this can be defined in ansible.playbooks
DEBUG    ubuntu_xenial ➜ validate: Validating schema /mnt/share/netology.git/ansible/08-ansible-05-testing/roles/clickhouse/molecule/ubuntu_xenial/molecule.yml.
WARNING  Driver docker does not provide a schema.
ERROR    Failed to validate /mnt/share/netology.git/ansible/08-ansible-05-testing/roles/clickhouse/molecule/ubuntu_xenial/molecule.yml

```
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
```sh

(pip) vboxuser@ubuntu:~/netology/ansible/08-ansible-05-testing/roles/vector$ molecule init scenario --driver-name docker
Usage: molecule init scenario [OPTIONS] [SCENARIO_NAME]
Try 'molecule init scenario -h' for help.

Error: No such option: --driver-name

```
```sh

(pip) vboxuser@ubuntu:~/netology/ansible/08-ansible-05-testing/roles/vector$ molecule init scenario -h
Usage: molecule init scenario [OPTIONS] [SCENARIO_NAME]

  Initialize a new scenario for use with Molecule.

Options:
  -h, --help  Show this message and exit.

```
3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
```yml
platforms:
  - name: ubuntu24
    image: ubuntu:latest

  - name: rocky9
    image: rockylinux:9
```
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
```yml
  tasks:
  - name: Execute vector
    command: vector --version
    changed_when: false
    register: vector_version_rc
  - name: Assert vector is installed
    assert:
      that:
        - vector_version_rc is success
```
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
```sh

    PLAY RECAP *********************************************************************
    rocky9                     : ok=14   changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
    ubuntu24                   : ok=16   changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

    INFO     ubuntun ➜ idempotence: Executed: Successful
    INFO     ubuntun ➜ side_effect: Executing
    WARNING  ubuntun ➜ side_effect: Executed: Missing playbook (Remove from test_sequence to suppress)
    INFO     ubuntun ➜ verify: Executing

```
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
```sh

[user@localhost vector]$ tox -e py39 | tee vector.log
py39: install_deps> python -I -m pip install -r tox-requirements.txt
py39: commands[0]> python --version
Python 3.9.21
py39: commands[1]> molecule --version
molecule 6.0.3 using python 3.9 
    ansible:2.15.13
    azure:23.6.0 from molecule_plugins
    containers:23.6.0 from molecule_plugins requiring collections: ansible.posix>=1.3.0 community.docker>=1.9.1 containers.podman>=1.8.1
    default:6.0.3 from molecule
    docker:23.6.0 from molecule_plugins requiring collections: community.docker>=3.4.11 ansible.posix>=1.4.0
    ec2:23.6.0 from molecule_plugins
    gce:23.6.0 from molecule_plugins requiring collections: google.cloud>=1.0.2 community.crypto>=1.8.0
    openstack:23.6.0 from molecule_plugins requiring collections: openstack.cloud>=2.1.0
    podman:23.6.0 from molecule_plugins requiring collections: containers.podman>=1.7.0 ansible.posix>=1.3.0
    vagrant:23.6.0 from molecule_plugins
py39: commands[2]> ansible --version
ansible [core 2.15.13]
  config file = /home/user/roles/vector/ansible.cfg
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/roles/vector/.tox/py39/lib/python3.9/site-packages/ansible
  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/user/roles/vector/.tox/py39/bin/ansible
  python version = 3.9.21 (main, Aug 19 2025, 00:00:00) [GCC 11.5.0 20240719 (Red Hat 11.5.0-5)] (/home/user/roles/vector/.tox/py39/bin/python)
  jinja version = 3.1.6
  libyaml = True
py39: commands[3]> ansible-playbook --version
ansible-playbook [core 2.15.13]
  config file = /home/user/roles/vector/ansible.cfg
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/roles/vector/.tox/py39/lib/python3.9/site-packages/ansible
  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/user/roles/vector/.tox/py39/bin/ansible-playbook
  python version = 3.9.21 (main, Aug 19 2025, 00:00:00) [GCC 11.5.0 20240719 (Red Hat 11.5.0-5)] (/home/user/roles/vector/.tox/py39/bin/python)
  jinja version = 3.1.6
  libyaml = True
py39: commands[4]> molecule create -s ubuntun
WARNING  Driver docker does not provide a schema.
INFO     ubuntun scenario test matrix: dependency, create, prepare
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'community.docker' 3.4.11 was found installed in /home/user/roles/vector/.tox/py39/lib/python3.9/site-packages/ansible_collections, only the first one will be used, 4.8.1 (/home/user/.ansible/collections/ansible_collections).
INFO     Running ubuntun > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntun > create
INFO     Sanity checks: 'docker'

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=ubuntu24)
ok: [localhost] => (item=rockylinux)
ok: [localhost] => (item=oracle8)

TASK [Create Dockerfiles from image names] *************************************
changed: [localhost] => (item=ubuntu24)
skipping: [localhost] => (item=rockylinux) 
skipping: [localhost] => (item=oracle8) 

TASK [Synchronization the context] *********************************************
changed: [localhost] => (item=ubuntu24)
skipping: [localhost] => (item=rockylinux) 
skipping: [localhost] => (item=oracle8) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item=unix://var/run/docker.sock)
ok: [localhost] => (item=unix://var/run/docker.sock)
ok: [localhost] => (item=unix://var/run/docker.sock)

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Build an Ansible compatible image (new)] *********************************
ok: [localhost] => (item=molecule_local/ubuntu:latest)
skipping: [localhost] => (item=molecule_local/geerlingguy/docker-rockylinux9-ansible:latest) 
skipping: [localhost] => (item=molecule_local/geerlingguy/docker-centos8-ansible:latest) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item=ubuntu24)
ok: [localhost] => (item=rockylinux)
ok: [localhost] => (item=oracle8)

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=ubuntu24)
changed: [localhost] => (item=rockylinux)
changed: [localhost] => (item=oracle8)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=ubuntu24)
changed: [localhost] => (item=rockylinux)
changed: [localhost] => (item=oracle8)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running ubuntun > prepare
WARNING  Skipping, prepare playbook not configured.
py39: commands[5]> molecule converge -s ubuntun
WARNING  Driver docker does not provide a schema.
INFO     ubuntun scenario test matrix: dependency, create, prepare, converge
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'community.docker' 3.4.11 was found installed in /home/user/roles/vector/.tox/py39/lib/python3.9/site-packages/ansible_collections, only the first one will be used, 4.8.1 (/home/user/.ansible/collections/ansible_collections).
INFO     Running ubuntun > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntun > create
WARNING  Skipping, instances already created.
INFO     Running ubuntun > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntun > converge
INFO     Sanity checks: 'docker'

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu24]
ok: [rockylinux]
ok: [oracle8]

TASK [Apply role under test] ***************************************************

TASK [vector : VECTOR | Check vector version] **********************************
fatal: [oracle8]: FAILED! => {"changed": false, "cmd": "vector --version", "msg": "[Errno 2] No such file or directory: b'vector': b'vector'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}                                                                                                                                                                                                             
fatal: [rockylinux]: FAILED! => {"changed": false, "cmd": "vector --version", "msg": "[Errno 2] No such file or directory: b'vector'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
fatal: [ubuntu24]: FAILED! => {"changed": false, "cmd": "vector --version", "msg": "[Errno 2] No such file or directory: b'vector'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
...ignoring
...ignoring
...ignoring

TASK [vector : Fetch vector repo install script] *******************************
ok: [ubuntu24]
ok: [oracle8]
ok: [rockylinux]

TASK [vector : Run vector repo installer] **************************************
changed: [rockylinux]
changed: [oracle8]
changed: [ubuntu24]

TASK [vector : Print pkg manager] **********************************************
ok: [oracle8] => {
    "msg": "PKG: dnf. MGR: systemd"
}
ok: [rockylinux] => {
    "msg": "PKG: dnf. MGR: systemd"
}
ok: [ubuntu24] => {
    "msg": "PKG: apt. MGR: sysvinit"
}

TASK [vector : include_tasks] **************************************************
included: /home/user/roles/vector/tasks/prepare.yml for oracle8, rockylinux, ubuntu24

TASK [vector : update apt cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
changed: [ubuntu24]

TASK [vector : update yum cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : update apk cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : update dnf cache] ***********************************************
skipping: [ubuntu24]
ok: [rockylinux]
ok: [oracle8]

TASK [vector : update zypper cache] ********************************************
skipping: [rockylinux]
skipping: [oracle8]
skipping: [ubuntu24]

TASK [vector : update pacman cache] ********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : Install necessary packages (e.g., git, curl)] *******************
skipping: [oracle8]
skipping: [rockylinux]
changed: [ubuntu24]

TASK [vector : include_tasks] **************************************************
included: /home/user/roles/vector/tasks/install/dnf.yml for rockylinux, oracle8
included: /home/user/roles/vector/tasks/install/apt.yml for ubuntu24

TASK [vector : Install by YUM | Ensure vector package installed (latest)] ******
skipping: [oracle8]
skipping: [rockylinux]

TASK [vector : Install by YUM | Ensure vector package installed (version 0.44.0)] ***
changed: [rockylinux]
changed: [oracle8]

TASK [vector : Debug (Install by APT | Package installation)] ******************
ok: [ubuntu24] => {
    "msg": [
        "vector=0.44.0-1"
    ]
}

TASK [vector : Install by APT | Package installation] **************************
changed: [ubuntu24]

TASK [vector : Install by APT | Package installation] **************************
skipping: [ubuntu24]

TASK [vector : Hold specified version during APT upgrade | Package installation] ***
changed: [ubuntu24] => (item=vector)

TASK [vector : VECTOR | User] **************************************************
included: /home/user/roles/vector/tasks/user.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Ensure vector group] ***********************************
ok: [ubuntu24]
ok: [rockylinux]
ok: [oracle8]

TASK [vector : VECTOR | Ensure vector user] ************************************
changed: [oracle8]
changed: [rockylinux]
changed: [ubuntu24]

TASK [vector : VECTOR | Ensure skeleton paths] *********************************
changed: [oracle8] => (item=/etc/vector)
changed: [rockylinux] => (item=/etc/vector)
changed: [ubuntu24] => (item=/etc/vector)

TASK [vector : VECTOR | Configure] *********************************************
included: /home/user/roles/vector/tasks/config.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Create templates config skeleton] **********************
skipping: [oracle8] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                               
skipping: [oracle8]
skipping: [rockylinux] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                            
skipping: [rockylinux]
skipping: [ubuntu24] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                              
skipping: [ubuntu24]

TASK [vector : VECTOR | Configure vector] **************************************
changed: [oracle8] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                                
changed: [rockylinux] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                             
changed: [ubuntu24] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                               

TASK [vector : VECTOR | Service] ***********************************************
included: /home/user/roles/vector/tasks/service.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Copy Daemon script] ************************************
changed: [oracle8]
changed: [rockylinux]
changed: [ubuntu24]

TASK [vector : VECTOR | Configuring service] ***********************************
changed: [rockylinux]
changed: [oracle8]
changed: [ubuntu24]

TASK [vector : Flush handlers] *************************************************

TASK [vector : Flush handlers] *************************************************

TASK [vector : Flush handlers] *************************************************

RUNNING HANDLER [vector : Restart vector] **************************************
changed: [rockylinux]
changed: [oracle8]
changed: [ubuntu24]

PLAY RECAP *********************************************************************
oracle8                    : ok=19   changed=8    unreachable=0    failed=0    skipped=8    rescued=0    ignored=1   
rockylinux                 : ok=19   changed=8    unreachable=0    failed=0    skipped=8    rescued=0    ignored=1   
ubuntu24                   : ok=22   changed=11   unreachable=0    failed=0    skipped=7    rescued=0    ignored=1   

py39: commands[6]> molecule test -s ubuntun --destroy=always
WARNING  Driver docker does not provide a schema.
INFO     ubuntun scenario test matrix: dependency, create, prepare, converge, destroy
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'community.docker' 3.4.11 was found installed in /home/user/roles/vector/.tox/py39/lib/python3.9/site-packages/ansible_collections, only the first one will be used, 4.8.1 (/home/user/.ansible/collections/ansible_collections).
INFO     Running ubuntun > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntun > create
WARNING  Skipping, instances already created.
INFO     Running ubuntun > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntun > converge
INFO     Sanity checks: 'docker'

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [rockylinux]
ok: [oracle8]
ok: [ubuntu24]

TASK [Apply role under test] ***************************************************

TASK [vector : VECTOR | Check vector version] **********************************
ok: [oracle8]
ok: [rockylinux]
ok: [ubuntu24]

TASK [vector : Fetch vector repo install script] *******************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : Run vector repo installer] **************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : Print pkg manager] **********************************************
ok: [oracle8] => {
    "msg": "PKG: dnf. MGR: systemd"
}
ok: [rockylinux] => {
    "msg": "PKG: dnf. MGR: systemd"
}
ok: [ubuntu24] => {
    "msg": "PKG: apt. MGR: sysvinit"
}

TASK [vector : include_tasks] **************************************************
included: /home/user/roles/vector/tasks/prepare.yml for oracle8, rockylinux, ubuntu24

TASK [vector : update apt cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
ok: [ubuntu24]

TASK [vector : update yum cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : update apk cache] ***********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : update dnf cache] ***********************************************
skipping: [ubuntu24]
ok: [oracle8]
ok: [rockylinux]

TASK [vector : update zypper cache] ********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : update pacman cache] ********************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : Install necessary packages (e.g., git, curl)] *******************
skipping: [oracle8]
skipping: [rockylinux]
ok: [ubuntu24]

TASK [vector : include_tasks] **************************************************
skipping: [oracle8]
skipping: [rockylinux]
skipping: [ubuntu24]

TASK [vector : VECTOR | User] **************************************************
included: /home/user/roles/vector/tasks/user.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Ensure vector group] ***********************************
ok: [oracle8]
ok: [rockylinux]
ok: [ubuntu24]

TASK [vector : VECTOR | Ensure vector user] ************************************
ok: [rockylinux]
ok: [oracle8]
ok: [ubuntu24]

TASK [vector : VECTOR | Ensure skeleton paths] *********************************
ok: [oracle8] => (item=/etc/vector)
ok: [rockylinux] => (item=/etc/vector)
ok: [ubuntu24] => (item=/etc/vector)

TASK [vector : VECTOR | Configure] *********************************************
included: /home/user/roles/vector/tasks/config.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Create templates config skeleton] **********************
skipping: [oracle8] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                               
skipping: [oracle8]
skipping: [rockylinux] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                            
skipping: [rockylinux]
skipping: [ubuntu24] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                              
skipping: [ubuntu24]

TASK [vector : VECTOR | Configure vector] **************************************
ok: [oracle8] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                                     
ok: [rockylinux] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})                                                                                  
ok: [ubuntu24] => (item={'root': '/home/user/roles/vector/tasks/templates/config/', 'path': 'vector.toml.j2', 'state': 'file', 'src': '/home/user/roles/vector/tasks/templates/config/vector.toml.j2', 'uid': 1000, 'gid': 1000, 'owner': 'user', 'group': 'user', 'mode': '0755', 'size': 868, 'mtime': 1760169658.0, 'ctime': 1760675917.2422974})

TASK [vector : VECTOR | Service] ***********************************************
included: /home/user/roles/vector/tasks/service.yml for oracle8, rockylinux, ubuntu24

TASK [vector : VECTOR | Copy Daemon script] ************************************
ok: [oracle8]
ok: [rockylinux]
ok: [ubuntu24]

TASK [vector : VECTOR | Configuring service] ***********************************
ok: [rockylinux]
ok: [oracle8]
ok: [ubuntu24]

TASK [vector : Flush handlers] *************************************************

TASK [vector : Flush handlers] *************************************************

TASK [vector : Flush handlers] *************************************************

PLAY RECAP *********************************************************************
oracle8                    : ok=14   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
rockylinux                 : ok=14   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
ubuntu24                   : ok=15   changed=0    unreachable=0    failed=0    skipped=9    rescued=0    ignored=0

INFO     Running ubuntun > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu24)
changed: [localhost] => (item=rockylinux)
changed: [localhost] => (item=oracle8)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=ubuntu24)
changed: [localhost] => (item=rockylinux)
changed: [localhost] => (item=oracle8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
  py39: OK (345.77=setup[60.27]+cmd[0.00,0.72,0.23,0.22,8.54,238.74,37.06] seconds)
  congratulations :) (345.82 seconds)

```
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
