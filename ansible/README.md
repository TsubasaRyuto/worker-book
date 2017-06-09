# ansible-rails
Ansible playbooks to set up rails environment on CentOS 7

# How to use
## install ansible (OSX)
```
$ brew update
$ brew install ansible
```

## setup hosts
```
$ cd ansible
```
- 秘密鍵を担当者からもらって~/.ssh/配下におく

## exec playbook
- staging環境の時
```
$ ansible-playbook webservers.yml -i staging
```
