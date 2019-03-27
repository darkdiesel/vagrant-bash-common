# Vagrant common configuration

## Table of content
- [Install](#install)
- [Useful Vagrant commands](#useful-vagrant-commands)

## Install
* [Upload](#site-src) upload project files
* [Put](#db-backups) db backup files
* Install VirtualBox on you machine from. See [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Install plugin vagrant-vbguest `vagrant plugin install vagrant-vbguest` *temp
* Run vagrant `vagrant up`
* Add to hosts `192.168.56.123  vagrant-common.loc wwww.vagrant.loc`

## Site src
* Copy project files and put it's to src folder

## Db backups
* db backup files ignored by git 
* Create database backup and put it to `data/db-backups/` folder
* Rename db backup file to `db.sql`

## Useful Vagrant commands
* Init new vagrant config -  `vagrant init`
* Run vagrant machine -  `vagrant up`
* Run vagrant machine with provision -  `vagrant up --provision`
* Check box update - `vagrant box update`
* Remove old version of vagrant boxes - `vagrant box prune`
* Connect to vagrant machine via ssh - `vagrant ssh`
* Remove vagrant machine - `vagrant destroy --force`