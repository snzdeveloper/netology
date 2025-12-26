# Ansible Role: teamcity

[![Lint](https://github.com/dcjulian29/ansible-role-teamcity/actions/workflows/lint.yml/badge.svg)](https://github.com/dcjulian29/ansible-role-teamcity/actions/workflows/lint.yml) [![GitHub Issues](https://img.shields.io/github/issues-raw/dcjulian29/ansible-role-teamcity.svg)](https://github.com/dcjulian29/ansible-role-teamcity/issues)

This an Ansible role to install a Teamcity Linux based agent with docker support or a Teamcity Server. Both run within a container and NGINX is also used as a reverse proxy to handle HTTPS connections.

## Requirements

- Internet Connection to download container images.

## Installation

To use, use `requirements.yml` with the following git source:

```yaml
---
roles:
- name: dcjulian29.teamcity
  src: https://github.com/dcjulian29/ansible-role-teamcity.git
  version: main
- name: dcjulian29.docker
  src: https://github.com/dcjulian29/ansible-role-docker.git
  version: main
- name: dcjulian29.nginx
  src: https://github.com/dcjulian29/ansible-role-nginx.git
  version: main
```

Then download it with `ansible-galaxy`:

```shell
ansible-galaxy install -r requirements.yml
```

## Dependencies

- Ansible Role: `dcjulian29.docker`
- Ansible Role: `dcjulian29.nginx`
- Ansible Role: `geerlingguy.pip`
