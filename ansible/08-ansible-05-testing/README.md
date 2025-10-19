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

[root@8487714abf86 vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.4.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.10.5,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==45.0.7,distro==1.9.0,docker==6.1.3,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.4.0,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-docker==1.1.0,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,ruamel.yaml==0.18.13,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,websocket-client==1.6.1,yamllint==1.32.0,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2048435008'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.4.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.10.5,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==45.0.7,distro==1.9.0,docker==6.1.3,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.4.0,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-docker==1.1.0,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,ruamel.yaml==0.18.13,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,websocket-client==1.6.1,yamllint==1.32.0,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='2048435008'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,ansible-lint==6.22.2,attrs==25.4.0,black==25.9.0,bracex==2.6,certifi==2025.10.5,cffi==2.0.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cryptography==46.0.2,distro==1.9.0,docker==7.1.0,enrich==1.2.7,filelock==3.19.1,idna==3.11,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.25.1,jsonschema-specifications==2025.9.1,lxml==6.0.2,markdown-it-py==3.0.0,MarkupSafe==3.0.3,mdurl==0.1.2,molecule==6.0.3,molecule-docker==2.1.0,molecule-podman==2.0.3,mypy_extensions==1.1.0,packaging==25.0,pathspec==0.12.1,platformdirs==4.4.0,pluggy==1.6.0,pycparser==2.23,Pygments==2.19.2,pytokens==0.1.10,PyYAML==6.0.3,referencing==0.36.2,requests==2.32.5,resolvelib==1.0.1,rich==14.2.0,rpds-py==0.27.1,ruamel.yaml==0.18.15,ruamel.yaml.clib==0.2.14,selinux==0.3.0,subprocess-tee==0.4.2,tomli==2.3.0,typing_extensions==4.15.0,urllib3==2.5.0,wcmatch==10.1,yamllint==1.37.1
py39-ansible210 run-test-pre: PYTHONHASHSEED='2048435008'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,ansible-lint==6.22.2,attrs==25.4.0,black==25.9.0,bracex==2.6,certifi==2025.10.5,cffi==2.0.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cryptography==46.0.2,distro==1.9.0,docker==7.1.0,enrich==1.2.7,filelock==3.19.1,idna==3.11,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.25.1,jsonschema-specifications==2025.9.1,lxml==6.0.2,markdown-it-py==3.0.0,MarkupSafe==3.0.3,mdurl==0.1.2,molecule==6.0.3,molecule-docker==2.1.0,molecule-podman==2.0.3,mypy_extensions==1.1.0,packaging==25.0,pathspec==0.12.1,platformdirs==4.4.0,pluggy==1.6.0,pycparser==2.23,Pygments==2.19.2,pytokens==0.1.10,PyYAML==6.0.3,referencing==0.36.2,requests==2.32.5,resolvelib==1.0.1,rich==14.2.0,rpds-py==0.27.1,ruamel.yaml==0.18.15,ruamel.yaml.clib==0.2.14,selinux==0.3.0,subprocess-tee==0.4.2,tomli==2.3.0,typing_extensions==4.15.0,urllib3==2.5.0,wcmatch==10.1,yamllint==1.37.1
py39-ansible30 run-test-pre: PYTHONHASHSEED='2048435008'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
_____________________________________________________________________________________________________ summary ______________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed

```

Если поменять название compatibility, непонятно откуда взявшееся, на название реально существующего сценария то так:

```sh
vboxuser@ubuntu:~/roles/vector$ docker run --privileged=True -v $(pwd):/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@8487714abf86 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.10.5,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==45.0.7,distro==1.9.0,docker==6.1.3,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.4.0,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-docker==1.1.0,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,websocket-client==1.6.1,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='270388554'
py37-ansible210 run-test: commands[0] | molecule test -s ubuntun --destroy always
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
INFO     ubuntun scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Running ubuntun > dependency
INFO     Running ansible-galaxy collection install -v --force community.docker:>=1.9.1
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntun > lint
/bin/sh: yamllint: command not found
/bin/sh: line 1: ansible-lint: command not found
WARNING  Retrying execution failure 127 of: y a m l l i n t   . 
 a n s i b l e - l i n t   . 

CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Running ubuntun > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntun > destroy
INFO     Sanity checks: 'docker'
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/base.py", line 118, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/base.py", line 160, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/base.py", line 149, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/logger.py", line 188, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/lint.py", line 100, in execute
    f"Lint failed with error code {result.returncode}"
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/util.py", line 118, in sysexit_with_message
    sysexit(code)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/util.py", line 96, in sysexit
    sys.exit(code)
SystemExit: 1

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connectionpool.py", line 803, in urlopen
    **response_kw,
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connectionpool.py", line 505, in _make_request
    enforce_content_length=enforce_content_length,
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connection.py", line 395, in request
    self.endheaders()
  File "/usr/local/lib/python3.7/http/client.py", line 1272, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.7/http/client.py", line 1032, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.7/http/client.py", line 972, in send
    self.connect()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/transport/unixconn.py", line 27, in connect
    sock.connect(self.unix_socket)
FileNotFoundError: [Errno 2] No such file or directory

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/requests/adapters.py", line 497, in send
    chunked=chunked,
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connectionpool.py", line 846, in urlopen
    method, url, error=new_e, _pool=self, _stacktrace=sys.exc_info()[2]
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/util/retry.py", line 470, in increment
    raise reraise(type(error), error, _stacktrace)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/util/util.py", line 38, in reraise
    raise value.with_traceback(tb)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connectionpool.py", line 803, in urlopen
    **response_kw,
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connectionpool.py", line 505, in _make_request
    enforce_content_length=enforce_content_length,
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/urllib3/connection.py", line 395, in request
    self.endheaders()
  File "/usr/local/lib/python3.7/http/client.py", line 1272, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.7/http/client.py", line 1032, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.7/http/client.py", line 972, in send
    self.connect()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/transport/unixconn.py", line 27, in connect
    sock.connect(self.unix_socket)
urllib3.exceptions.ProtocolError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/api/client.py", line 214, in _retrieve_server_version
    return self.version(api_version=False)["ApiVersion"]
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/api/daemon.py", line 181, in version
    return self._result(self._get(url), json=True)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/utils/decorators.py", line 46, in inner
    return f(self, *args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/api/client.py", line 237, in _get
    return self.get(url, **self._set_request_timeout(kwargs))
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/requests/sessions.py", line 602, in get
    return self.request("GET", url, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/requests/sessions.py", line 589, in request
    resp = self.send(prep, **send_kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/requests/sessions.py", line 703, in send
    r = adapter.send(request, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/requests/adapters.py", line 501, in send
    raise ConnectionError(err, request=request)
requests.exceptions.ConnectionError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible210/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/test.py", line 161, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/base.py", line 129, in execute_cmdline_scenarios
    execute_subcommand(scenario.config, "destroy")
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/base.py", line 149, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/logger.py", line 188, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/provisioner/ansible.py", line 706, in destroy
    pb.execute()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule/provisioner/ansible_playbook.py", line 110, in execute
    self._config.driver.sanity_checks()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule_docker/driver.py", line 236, in sanity_checks
    docker_client = docker.from_env()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/client.py", line 101, in from_env
    **kwargs_from_env(**kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/client.py", line 45, in __init__
    self.api = APIClient(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/api/client.py", line 197, in __init__
    self._version = self._retrieve_server_version()
  File "/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/docker/api/client.py", line 222, in _retrieve_server_version
    f'Error while fetching server API version: {e}'
docker.errors.DockerException: Error while fetching server API version: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s ubuntun --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.10.5,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==45.0.7,distro==1.9.0,docker==6.1.3,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.4.0,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-docker==1.1.0,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,websocket-client==1.6.1,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='270388554'
py37-ansible30 run-test: commands[0] | molecule test -s ubuntun --destroy always
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
INFO     ubuntun scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Running ubuntun > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntun > lint
/bin/sh: yamllint: command not found
/bin/sh: line 1: ansible-lint: command not found
WARNING  Retrying execution failure 127 of: y a m l l i n t   . 
 a n s i b l e - l i n t   . 

CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Running ubuntun > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntun > destroy
INFO     Sanity checks: 'docker'
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/base.py", line 118, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/base.py", line 160, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/base.py", line 149, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/logger.py", line 188, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/lint.py", line 100, in execute
    f"Lint failed with error code {result.returncode}"
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/util.py", line 118, in sysexit_with_message
    sysexit(code)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/util.py", line 96, in sysexit
    sys.exit(code)
SystemExit: 1

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connectionpool.py", line 803, in urlopen
    **response_kw,
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connectionpool.py", line 505, in _make_request
    enforce_content_length=enforce_content_length,
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connection.py", line 395, in request
    self.endheaders()
  File "/usr/local/lib/python3.7/http/client.py", line 1272, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.7/http/client.py", line 1032, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.7/http/client.py", line 972, in send
    self.connect()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/transport/unixconn.py", line 27, in connect
    sock.connect(self.unix_socket)
FileNotFoundError: [Errno 2] No such file or directory

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/requests/adapters.py", line 497, in send
    chunked=chunked,
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connectionpool.py", line 846, in urlopen
    method, url, error=new_e, _pool=self, _stacktrace=sys.exc_info()[2]
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/util/retry.py", line 470, in increment
    raise reraise(type(error), error, _stacktrace)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/util/util.py", line 38, in reraise
    raise value.with_traceback(tb)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connectionpool.py", line 803, in urlopen
    **response_kw,
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connectionpool.py", line 505, in _make_request
    enforce_content_length=enforce_content_length,
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/urllib3/connection.py", line 395, in request
    self.endheaders()
  File "/usr/local/lib/python3.7/http/client.py", line 1272, in endheaders
    self._send_output(message_body, encode_chunked=encode_chunked)
  File "/usr/local/lib/python3.7/http/client.py", line 1032, in _send_output
    self.send(msg)
  File "/usr/local/lib/python3.7/http/client.py", line 972, in send
    self.connect()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/transport/unixconn.py", line 27, in connect
    sock.connect(self.unix_socket)
urllib3.exceptions.ProtocolError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/api/client.py", line 214, in _retrieve_server_version
    return self.version(api_version=False)["ApiVersion"]
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/api/daemon.py", line 181, in version
    return self._result(self._get(url), json=True)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/utils/decorators.py", line 46, in inner
    return f(self, *args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/api/client.py", line 237, in _get
    return self.get(url, **self._set_request_timeout(kwargs))
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/requests/sessions.py", line 602, in get
    return self.request("GET", url, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/requests/sessions.py", line 589, in request
    resp = self.send(prep, **send_kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/requests/sessions.py", line 703, in send
    r = adapter.send(request, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/requests/adapters.py", line 501, in send
    raise ConnectionError(err, request=request)
requests.exceptions.ConnectionError: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py37-ansible30/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/test.py", line 161, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/base.py", line 129, in execute_cmdline_scenarios
    execute_subcommand(scenario.config, "destroy")
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/base.py", line 149, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/logger.py", line 188, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/provisioner/ansible.py", line 706, in destroy
    pb.execute()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule/provisioner/ansible_playbook.py", line 110, in execute
    self._config.driver.sanity_checks()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/molecule_docker/driver.py", line 236, in sanity_checks
    docker_client = docker.from_env()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/client.py", line 101, in from_env
    **kwargs_from_env(**kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/client.py", line 45, in __init__
    self.api = APIClient(*args, **kwargs)
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/api/client.py", line 197, in __init__
    self._version = self._retrieve_server_version()
  File "/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/docker/api/client.py", line 222, in _retrieve_server_version
    f'Error while fetching server API version: {e}'
docker.errors.DockerException: Error while fetching server API version: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s ubuntun --destroy always (exited with code 1)
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.4.0,bracex==2.6,certifi==2025.10.5,cffi==2.0.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cryptography==46.0.2,distro==1.9.0,docker==7.1.0,enrich==1.2.7,idna==3.11,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.25.1,jsonschema-specifications==2025.9.1,lxml==6.0.2,markdown-it-py==3.0.0,MarkupSafe==3.0.3,mdurl==0.1.2,molecule==6.0.3,molecule-docker==2.1.0,molecule-podman==2.0.3,packaging==25.0,pluggy==1.6.0,pycparser==2.23,Pygments==2.19.2,PyYAML==6.0.3,referencing==0.36.2,requests==2.32.5,resolvelib==1.0.1,rich==14.2.0,rpds-py==0.27.1,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.15.0,urllib3==2.5.0,wcmatch==10.1
py39-ansible210 run-test-pre: PYTHONHASHSEED='270388554'
py39-ansible210 run-test: commands[0] | molecule test -s ubuntun --destroy always
WARNING  Driver docker does not provide a schema.
INFO     ubuntun scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Running ubuntun > dependency
WARNING  Retrying execution failure 250 of: ansible-galaxy collection install -vvv ansible.posix:>=1.4.0
ERROR    Command ansible-galaxy collection install -vvv ansible.posix:>=1.4.0, returned 250 code:
the full traceback was:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible210/bin/ansible-galaxy", line 92, in <module>
    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=), myclass)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>
    from ansible.galaxy.collection import (
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>
    from ansible.galaxy.collection.concrete_artifact_manager import (
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>
    from ansible.galaxy.api import should_retry_error
ImportError: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible210/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/test.py", line 113, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 123, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 166, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 156, in execute_subcommand
    return command(config).execute(args)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/logger.py", line 189, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/dependency.py", line 40, in execute
    self._config.dependency.execute()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/dependency/ansible_galaxy/__init__.py", line 95, in execute
    invoker.execute()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/dependency/ansible_galaxy/base.py", line 115, in execute
    super().execute()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/dependency/base.py", line 91, in execute
    self._config.runtime.require_collection(name, version)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 776, in require_collection
    self.install_collection(f"{name}:>={version}")
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 535, in install_collection
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Command ansible-galaxy collection install -vvv ansible.posix:>=1.4.0, returned 250 code:
the full traceback was:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible210/bin/ansible-galaxy", line 92, in <module>
    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=[myclass]), myclass)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>
    from ansible.galaxy.collection import (
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>
    from ansible.galaxy.collection.concrete_artifact_manager import (
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>
    from ansible.galaxy.api import should_retry_error
ImportError: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s ubuntun --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.4.0,bracex==2.6,certifi==2025.10.5,cffi==2.0.0,charset-normalizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cryptography==46.0.2,distro==1.9.0,docker==7.1.0,enrich==1.2.7,idna==3.11,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.25.1,jsonschema-specifications==2025.9.1,lxml==6.0.2,markdown-it-py==3.0.0,MarkupSafe==3.0.3,mdurl==0.1.2,molecule==6.0.3,molecule-docker==2.1.0,molecule-podman==2.0.3,packaging==25.0,pluggy==1.6.0,pycparser==2.23,Pygments==2.19.2,PyYAML==6.0.3,referencing==0.36.2,requests==2.32.5,resolvelib==1.0.1,rich==14.2.0,rpds-py==0.27.1,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.15.0,urllib3==2.5.0,wcmatch==10.1
py39-ansible30 run-test-pre: PYTHONHASHSEED='270388554'
py39-ansible30 run-test: commands[0] | molecule test -s ubuntun --destroy always
WARNING  Driver docker does not provide a schema.
INFO     ubuntun scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Running ubuntun > dependency
WARNING  Retrying execution failure 250 of: ansible-galaxy collection install -vvv ansible.posix:>=1.4.0
ERROR    Command ansible-galaxy collection install -vvv ansible.posix:>=1.4.0, returned 250 code:
the full traceback was:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible30/bin/ansible-galaxy", line 92, in <module>
    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=), myclass)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>
    from ansible.galaxy.collection import (
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>
    from ansible.galaxy.collection.concrete_artifact_manager import (
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>
    from ansible.galaxy.api import should_retry_error
ImportError: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible30/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/test.py", line 113, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 123, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 166, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 156, in execute_subcommand
    return command(config).execute(args)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/logger.py", line 189, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/dependency.py", line 40, in execute
    self._config.dependency.execute()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/dependency/ansible_galaxy/__init__.py", line 95, in execute
    invoker.execute()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/dependency/ansible_galaxy/base.py", line 115, in execute
    super().execute()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/dependency/base.py", line 91, in execute
    self._config.runtime.require_collection(name, version)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 776, in require_collection
    self.install_collection(f"{name}:>={version}")
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 535, in install_collection
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Command ansible-galaxy collection install -vvv ansible.posix:>=1.4.0, returned 250 code:
the full traceback was:

Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible30/bin/ansible-galaxy", line 92, in <module>
    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=[myclass]), myclass)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>
    from ansible.galaxy.collection import (
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>
    from ansible.galaxy.collection.concrete_artifact_manager import (
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>
    from ansible.galaxy.api import should_retry_error
ImportError: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)

ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s ubuntun --destroy always (exited with code 1)
_____________________________________________________________________________________________________ summary ______________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed

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
