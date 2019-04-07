# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load settings from yml configs
require 'yaml'

settings = YAML.load_file './vagrant/default.yml'

if File.exist?("./vagrant/settings.yml")
  user_settings = YAML.load_file './vagrant/settings.yml'
  settings.merge!(user_settings)
else
  abort "WARNING! Before running the machine you should create copy of ./vagrant/settings.example.yml  and put in ./vagrant folder with settings.yml name."
end

VAGRANTFILE_API_VERSION = "2"

OS_BOX = settings['VAGRANT']['BOX']

# Official OS name. used for locate correspond scripts for operation system
OS_NAME =  settings['VAGRANT']['OS']

MACHINE_IP = settings['VAGRANT']['IP']

MACHINE_NAME = settings['SITES']['BASE_DOMAIN']
BASE_DOMAIN = "vagrant"

required_plugins = %w( vagrant-hostmanager )

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort "ERROR! Installation of one or more plugins has failed. Aborting."
    end
end


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = OS_BOX

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 8080, id: "http", auto_correct: true
  config.vm.network "forwarded_port", guest: 22, host: 2200, id: "ssh", auto_correct: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: MACHINE_IP

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "./vagrant", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./data", "/vagrant_data", type: "virtualbox"
  config.vm.synced_folder "./src", "/var/www/", type: "virtualbox",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=755,fmode=664"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.define MACHINE_NAME + "." + BASE_DOMAIN do |machine|
    machine.vm.hostname = MACHINE_NAME

    machine.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true

      # Customize the amount of memory on the VM:
      vb.memory = "1024"

      # Vagrant Machine Name
      vb.name = MACHINE_NAME + "." + BASE_DOMAIN

      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  
  config.vm.provision "shell", path: "./vagrant/scripts/"+OS_NAME+"/_bootstrap.sh"

  # Start mailcatcher service when vagrant machine started
  # config.vm.provision "shell", inline: '/usr/bin/env mailcatcher --http-ip=0.0.0.0', privileged: false, run: "always"

  # vagrant hostmanager plugin
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    # build hosts array
    hosts_arr = ["www.#{MACHINE_NAME}"]
      if settings['PACKAGES']['PHPMYADMIN']
        hosts_arr.push("pma.#{MACHINE_NAME}")
      end

      if settings['PACKAGES']['MAILCATCHER']
        hosts_arr.push("mailcatcher.#{MACHINE_NAME}")
      end

      for i in 1..settings['SITES']['COUNT']
        cur_site_domain = settings['SITES']["SITE_#{i}"]['DOMAIN']

        hosts_arr.push(cur_site_domain)
        hosts_arr.push("www.#{cur_site_domain}")
      end

    config.hostmanager.aliases = hosts_arr
  else
    abort "ERROR! Vagrant plugin vagrant-hostmanager is not installed!"
  end
end
