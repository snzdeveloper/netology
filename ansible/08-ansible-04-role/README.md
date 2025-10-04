# Домашнее задание к занятию 4 «Работа с roles»

Playbook устанавливает clickhouse, vector и lighthouse с использованием ролей из git репозитариев 

```sh
ansible-galaxy install -r requirements.yml -p roles --force

ansible-playbook -i inventory/prod.yml site.yml

```
---

Playbook устанавливает clickhouse, vector и lighthouse с использованием ролей из git репозитариев 

```sh
ansible-galaxy install -r requirements.yml -p roles --force

ansible-playbook -i inventory/prod.yml site.yml

```