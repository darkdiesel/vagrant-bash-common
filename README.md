# Vagrant machine builder

Create you virtual machine on ubuntu or debian with soft that you need for you project. Check [suported os](#supported-os) section for mo details. 

## Table of content
- [Install](#install)
- [Settings](#vagrant-settings-example)
- [Vagrant commands](#vagrant-useful-commands)
- [PM2 commands](#pm2-useful-commands)
- [Custom scripts](#custom-scripts)
- [Supported OS](#supported-os)

## Install
* Copy project files and put it's to `./src` folder. Names of folders should be the same as domain for site
* Put db backup files to `data/dumps`. More [here](#where-put-db-backups-files)
* Make copy of `vagrant/settings.example.yml` and save as `vagrant/settings.yml`. Check [example](#vagrant-settings-example) how to set up
* Install VirtualBox on your machine. Check [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Run vagrant `vagrant up`
* Required plugins should be installed automatically. If not check [vagrant plugins requirements](#vagrant-plugins-requirements) section
* Hosts should be updated automatically but if not add it's manually `<machine_ip> <main_site_domain> pma.<main_site_domain> mailhog.<main_site_domain> mailcatcher.<main_site_domain>` 

### Where put db backups files?
* Create database backup and put it to `./data/dumps/` folder
* Rename db backup file to *`<dbname>.sql`* to run for appropriated database
* Configure db for each site separately on `settings.yml`

## Vagrant settings example
```yaml
VAGRANT:
  HOSTNAME: site.loc
  BOX: ubuntu/focal64
  OS: ubuntu/focal
  IP: 192.168.56.101
  CPU: 1
  MEMORY: 1024
  GUI: true
  FS_NOTIFY: false
SITES:
  COUNT: 3
  BASE_PATH: /var/www/
  SITE_1:
    DOMAIN: site.loc
    ROOT: /
    DB:
      NAME: vagrant
      USER: vagrant_usr
      PASS: 123456q
      PROVISION_RESET: YES
  SITE_2:
    DOMAIN: drupal.site.loc}
    ROOT: /web
    DRUPAL: YES
    DB:
      NAME: drupal
      USER: drupal_usr
      PASS: 123456q
      PROVISION_RESET: YES
  SITE_3:
    DOMAIN: vue.site.loc
    ROOT: /
    NPM: YES
    PORT: 3000
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
  MYSQL:
    INSTALL: NO
    VERSION: 8.0
  PHP:
    INSTALL: YES
    VERSION: 7.4
  COMPOSER: YES
  REDIS: YES
  NODEJS:
    INSTALL: NO
    VERSION: 10
  NPM:
    INSTALL: NO
  PM2: NO
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
    - `FS_NOTIFY`: If you working with builders in watch mode and you need restart build every time when file changed you need activate this option to notify file system on virtual machine. 
- `SITES`: 
    - `COUNT`: Count of sites that you need to create
    - `BASE_DOMAIN`: Host domain that will be available after setup. By default, used for site folder name
    - `BASE_PATH`: Site location on virtual machine
- `PACKEGES`:
  - `PM2`: Daemon process manager for node projects. Check [usefull commands](#pm2-useful-commands) to set up you server

## Vagrant plugins requirements
Required plugins should be installed automatically. If not - run manually installation by command `vagrant plugin install <plugin name>` for each of next plugins:
 - [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
 - [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

## Vagrant useful commands
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

## PM2 Useful commands
* `pm2 list` - To list all running applications and check status
* `pm2 status` - To list all running applications and check status
* `pm2 stop 2` - Stop process id = 2 
* `pm2 start 2` - Start process id = 2
* `pm2 restart 2` - Restart process id = 2
* `pm2 describe 2` - Show all info (command, status) about process id = 2
* `pm2 start --name website.loc npm -- run build` - Create process with name = `website.loc` and attaches command `npm run build`
* `pm2 save` - Save current process list
* `pm2 resurrect` - Restore previously saved processes
* `pm2 unstartup` - Disable and remove startup system
* `pm2 startup` - Detect init system, generate and configure pm2 boot on startup.
    after running this command you will get something like this, copy past and execute: 
    ```bash 
    sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
    ```
    then run `pm2 save`

## Custom scripts
To add custom scripts for project additional configuration - put bash files to `/vagrant/scripts_custom`.
All files from this folder will be executed in the end after main setup of virtual machine

## Supported OS
### Ubuntu:
* `ubuntu/trusty` - 14.04
* `ubuntu/xenial` - 16.04 [detail](#ubuntu-xenial)
* `ubuntu/bionic` - 18.04
* `ubuntu/focal`  - 20.04 [detail](#ubuntu-focal)
* `ubuntu/jammy`  - 22.04 [detail](#ubuntu-jammy)
* `ubuntu/mantic` - 23.10 [detail](#ubuntu-mantic)
### Debian:
* `debian/stretch` - 9
* `debian/buster` - 10 (TODO)

Find more vagrant boxes [here](https://app.vagrantup.com/boxes/search) and create PR with new for this repo :)

## Avalable Packages Version
* `drush`: `All` - go [package page](https://packagist.org/packages/drush/drush) and [drupal compatibility](https://docs.drush.org/en/master/install/#drupal-compatibility)
* `nodejs`: [4](https://deb.nodesource.com/setup_4.x) - [12](https://deb.nodesource.com/setup_12.x). Go [repo](https://deb.nodesource.com/) for more info

## Packages Requirements
* `composer`: `php`
* `drush`: `composer`
* `mailhog`: `git`, `golang-go`, `php`
* `mailcatcher`: `ryby`, `sqllite3`
* `pm2`: 'nodejs'
* `highcharts export server`: `nodejs`

## ubuntu xenial

**Config:**
```yaml
VAGRANT:
  BOX: ubuntu/xeniall64
  OS: ubuntu/xenial
```

**Soft:**
```text
PHP: 7.0
MARIADB: 10.4
XDEBUG: ~2.4.0
NGINX: ~1.10.3
APACHE2: ~2.4.18
```

## ubuntu focal

**Config:**
```yaml
VAGRANT:
  BOX: ubuntu/focal64
  OS: ubuntu/focal
```

**Soft:**
```text
PHP: 7.4
MARIADB: 10.4
```
## ubuntu jammy

**Config:**
```yaml
VAGRANT:
  BOX: ubuntu/jammy64
  OS: ubuntu/jammy
```

**Soft:**
```text
PHP: 8.1
MARIADB: 10.6
XDEBUG: ~3.1.2
NGINX: ~1.18.0
APACHE2: ~2.4.52
```

## ubuntu mantic

**Config:**
```yaml
VAGRANT:
  BOX: ubuntu/mantic64
  OS: ubuntu/mantic
```

**Soft:**
```text
PHP: 8.2 | 8.3
MARIADB: 11.3
MYSQL: 8.0
XDEBUG: ~3.1.2
NGINX: ~1.18.0
APACHE2: ~2.4.52
```