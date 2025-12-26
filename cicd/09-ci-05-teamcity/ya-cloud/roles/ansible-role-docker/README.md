# Ansible Role: docker

[![Lint](https://github.com/dcjulian29/ansible-role-docker/actions/workflows/lint.yml/badge.svg)](https://github.com/dcjulian29/ansible-role-docker/actions/workflows/lint.yml) [![GitHub Issues](https://img.shields.io/github/issues-raw/dcjulian29/ansible-role-docker.svg)](https://github.com/dcjulian29/ansible-role-docker/issues)

This an Ansible role to install Docker and related utilities to manage containers.

## Requirements

- Internet Connection to download packagrs.

## Installation

To use, use `requirements.yml` with the following git source:

```yaml
---
roles:
- name: dcjulian29.docker
  src: https://github.com/dcjulian29/ansible-role-docker.git
  version: main
  ```

Then download it with `ansible-galaxy`:

```shell
ansible-galaxy install -r requirements.yml
```

## Dependencies

- Ansible Role: `geerlingguy.pip`
