# Vagrant common configuration

### Vagrant installation ###
* [Upload](#site-src) upload project files
* [Check](#db-backups) db backup files
* Install VirtualBox on you machine from. See [virtualbox.org](https://www.virtualbox.org/) for installation package.
* Vagrant Box init wih ubuntu/trusty64 box. Before start vagrant check for box last version `vagrant box update`
* Install plugin vagrant-vbguest `vagrant plugin install vagrant-vbguest`
* Run vagrant `vagrant up`
* Add to hosts `192.168.56.123  vagrant-common.loc wwww.vagrant.loc`
* Note! After installation complete [update](#update-db-links) db links.

#### Site src
* Copy project files and put it's to src folder

#### Db backups
* db backup files ignored by git 
* Create database backup and put it to `data/db-backups/` folder
* Rename db backup file to `db.sql`


