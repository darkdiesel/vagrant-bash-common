# Vagrant common configuration

## Table of content
- [Setup](#setup)
- [Install](#install)
- [Vagrant Settings](#vagrant-settings)
- [Useful vagrant commands](#useful-vagrant-commands)

## Setup
Before running vagrant machine create  config file.
Create a copy of the file`./vagrant/settings.example.yml` and put in `vagrant` folder with `settings.yml` name.

Check [Vagrant settings](#vagrant-settings) section for more detail of each param.

## Install
* [Upload](#site-src) project files
* [Put](#db-backups) db backup files
* Install VirtualBox on you machine from. See [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Install plugin vagrant-vbguest `vagrant plugin install vagrant-vbguest` *temp
* Run vagrant `vagrant up`
* Required plugins should be installed automatically. If not check [vagrant plugins requirements](#vagrant-plugins-requirements) section
* Add to hosts `192.168.56.123  vagrant-common.loc wwww.vagrant-common.loc`

## Where put site sources?
* Copy project files and put it's to `./src` folder

## Where put db backups files?
* db backup files ignored by git 
* Create database backup and put it to `./data/db-backups/` folder
* Rename db backup file to *`db.sql`*

## Vagrant settings
Detail list of vagrant configuration file. **settings.example.yml**:
```yml
VAGRANT:
  BOX: ubuntu/trusty64
  OS: ubuntu/trusty
  IP: 192.168.56.2
MAIN_SITE:
  DOMAIN: vagrant-common.loc
```

- **`VAGRANT`**: section for vagrant settings
    - **`BOX`**: Vagrant box name. Visit [public catalog of Vagrant boxes](https://app.vagrantup.com/boxes/search) to find more boxes. Check [Supported OS](#supported-os) section for find supporting boxes.
    - **`OS`**: Official operation system name. Format: *`<linux distribution name>/<release code name>`*.
    - **`IP`**: Ip address of vagrant machine
- **`MAIN_SITE`**: 
    - **`DOMAIN`**: Main domain of project

## Vagrant plugins requirements
Required plugins should be installed automatically. If not - run manually installation by command `vagrant plugin install <plugin name>` for each of next plugins:
 - [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)

## Useful vagrant commands
* Init new vagrant config -  `vagrant init`
* Run vagrant machine -  `vagrant up`
* Run vagrant machine with provision -  `vagrant up --provision`
* Check box update - `vagrant box update`
* Remove old version of vagrant boxes - `vagrant box prune`
* Connect to vagrant machine via ssh - `vagrant ssh`
* Remove vagrant machine - `vagrant destroy --force`

## Supported OS
* ubuntu/trusty
* ubuntu/bionic