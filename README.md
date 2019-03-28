# Vagrant common configuration

## Table of content
- [Setup](#setup)
- [Install](#install)
- [Vagrant Settings](#vagrant-settings)
- [Useful vagrant commands](#useful-vagrant-commands)

## Setup
Before running vagrant machine create  config file.
Create a copy of the file`settings.example.yml` and put near `Vagrantfile` with `settings.yml` name.

Check [Vagrant settings](#vagrant-settings) section for more detail of each param.

## Install
* [Upload](#site-src) project files
* [Put](#db-backups) db backup files
* Install VirtualBox on you machine from. See [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Install plugin vagrant-vbguest `vagrant plugin install vagrant-vbguest` *temp
* Run vagrant `vagrant up`
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
vagrant:
  box: ubuntu/trusty64
  os_name: ubuntu/trusty
  ip: 192.168.56.2
project:
  main_domain: vagrant-common.loc
  os_name: vagrant-ubuntu-14
```

- **`vagrant`**: section for vagrant settings
    - **`box`**: Vagrant box name. Visit [public catalog of Vagrant boxes](https://app.vagrantup.com/boxes/search) to find more boxes.
    - **`os_name`**: Official operation system name. Format: *`<linux distribution name>/<release code name>`*.
    - **`ip`**: Ip address of vagrant machine
- **`project`**: 
    - **`main_domain`**: Main domain of project
    - **`os_name`**: Operation system name. Used for naming folder of machine in *.vagrant/machines* directory

## Useful vagrant commands
* Init new vagrant config -  `vagrant init`
* Run vagrant machine -  `vagrant up`
* Run vagrant machine with provision -  `vagrant up --provision`
* Check box update - `vagrant box update`
* Remove old version of vagrant boxes - `vagrant box prune`
* Connect to vagrant machine via ssh - `vagrant ssh`
* Remove vagrant machine - `vagrant destroy --force`