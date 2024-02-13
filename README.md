# Vagrant common configuration

## Table of content
- [Setup](#setup)
- [Install](#install)
- [Vagrant Settings](#vagrant-settings)
- [Useful vagrant commands](#useful-vagrant-commands)

## Setup
Before running vagrant machine create config file.
Create a copy of the file`./vagrant/settings.example.yml` and put in `vagrant` folder with `settings.yml` name.

Check [Vagrant settings](#vagrant-settings) section for more detail of each param.

## Install
* [Upload](#site-src) project files
* [Put](#db-backups) db backup files
* Install VirtualBox on you machine from. See [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Run vagrant `vagrant up`
* Required plugins should be installed automatically. If not check [vagrant plugins requirements](#vagrant-plugins-requirements) section
* Hosts should be updated automatically but if not add it's manually `<machine_ip> <main_site_domain> pma.<main_site_domain> mailcatcher.<main_site_domain>` 

## Where put site sources?
* Copy project files and put it's to `./src` folder

## Where put db backups files?
* db backup files ignored by git 
* Create database backup and put it to `./data/db-backups/` folder
* Rename db backup file to *`db.sql`*

## Vagrant settings
Detail list of vagrant configuration file. **settings.example.yml**:
```yaml
VAGRANT:
  BOX: ubuntu/focal64
  OS: ubuntu/focal
  IP: 192.168.56.101
  CPU: 1
  MEMORY: 1024
  GUI: true
SITES:
  COUNT: 1
  BASE_DOMAIN: vagrant-common.loc
  BASE_PATH: /var/www/
  SITE_1:
    DOMAIN: ${SITES__BASE_DOMAIN}
    DIR: ${SITES__SITE_1__DOMAIN}
    PATH: ${SITES__BASE_PATH}${SITES__SITE_1__DOMAIN}/
    DRUPAL: NO
    DB:
      NAME: vagrant
      USER: vagrant_usr
      PASS: 123456q
      PROVISION_RESET: YES
DB:
  USER: root
  PASS: 123456q
  PROVISION_RESET: YES
PACKAGES:
  MC: YES
  HTOP: YES
  GIT: YES
  VIM: YES
  APACHE2: YES
  NGINX: YES
  MARIADB:
    INSTALL: YES
    VERSION: 10.4
  PHP:
    INSTALL: YES
    VERSION: 7.4
  COMPOSER: YES
  REDIS: YES
  NODEJS:
    INSTALL: NO
    VERSION: 10
  HIGHCHARTS_EXPORT_SERVER:
    INSTALL: NO
    VERSION: latest
  SENDMAIL: YES
  PHPMYADMIN: YES
  MAILHOG: YES
  MAILCATCHER: NO
  DRUSH:
    INSTALL: NO
    VERSION: 9.x
  WP_CLI: NO
```

- `VAGRANT`: section for vagrant settings
    - `BOX`: Vagrant box name. Visit [public catalog of Vagrant boxes](https://app.vagrantup.com/boxes/search) to find more boxes. Check [Supported OS](#supported-os) section for find supporting boxes.
    - `OS`: Official operation system name. Format: *`<linux distribution name>/<release code name>`*.
    - `IP`: Ip address of vagrant machine
    - `GUI`: Show virtual machine interface
- `SITES`: 
    - `COUNT`: Count of sites that you need to create
    - `BASE_DOMAIN`: Host domain that will be available after setup. By default, used for site folder name
    - `BASE_PATH`: Site location on virtual machine

## Vagrant plugins requirements
Required plugins should be installed automatically. If not - run manually installation by command `vagrant plugin install <plugin name>` for each of next plugins:
 - [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
 - [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

## Useful vagrant commands
* `vagrant init` - init new vagrant config  
* `vagrant up` - run vagrant machine
* `vagrant up --provision` - run vagrant machine with provision (run installation scripts)  
* `vagrant reload` - reload virtual machine
* `vagrant reload --provision` - reload virtual machine and run provision (run installation scripts)
* `vagrant box update` - update box for current vagrant instance 
* `vagrant box prune` - remove old version of vagrant boxes 
* `vagrant ssh` - connect to vagrant machine via ssh 
* `vagrant destroy` - remove vagrant machine
* `vagrant destroy --force` - remove vagrant machine force flow

## Supported OS
### Ubuntu:
* `ubuntu/trusty` - 14.04
* `ubuntu/xenial` - 16.04 [detail](#ubuntu-xenial)
* `ubuntu/bionic` - 18.04
* `ubuntu/focal`  - 20.04 [detail](#ubuntu-focal)
* `ubuntu/jammy`  - 22.04 [detail](#ubuntu-jammy)
### Debian:
* `debian/stretch` - 9
* `debian/buster` - 10 (TODO)

Find more vagrant boxes [here](https://app.vagrantup.com/boxes/search)

## Avalable Packages Version
* `php`: `5.6`, `7.0`, `7.1`, `7.2`
* `mariadb`: `10.2`, `10.3`
* `drush`: `All` - go [package page](https://packagist.org/packages/drush/drush) and [drupal compatibility](https://docs.drush.org/en/master/install/#drupal-compatibility)
* `nodejs`: [4](https://deb.nodesource.com/setup_4.x) - [12](https://deb.nodesource.com/setup_12.x). Go [repo](https://deb.nodesource.com/) for more info

## Packages Requirements 
* `mailhog`: `git`, `golang-go`
* `drush`: `composer`
* `composer`: `php`

## ubuntu xenial

Config:
```yaml
VAGRANT:
  BOX: ubuntu/xeniall64
  OS: ubuntu/xenial
```

Soft:
```text
PHP: 7.0
MARIADB: 10.4
XDEBUG: ~2.4.0
NGINX: ~1.10.3
NGINX: ~2.4.18
```

## ubuntu focal

Config:
```yaml
VAGRANT:
  BOX: ubuntu/focal64
  OS: ubuntu/focal
```

Soft:
```text
PHP: 7.4
MARIADB: 10.4
```
## ubuntu jammy

Config:
```yaml
VAGRANT:
  BOX: ubuntu/jammy64
  OS: ubuntu/jammy
```

Soft:
```text
PHP: 8.1
MARIADB: 10.6
```
