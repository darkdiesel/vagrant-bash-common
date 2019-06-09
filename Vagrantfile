# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_ROOT = File.dirname(__FILE__)

# Load settings from yml configs
require 'yaml'

SETTINGS = YAML.load_file("#{VAGRANT_ROOT}/vagrant/default.yml")

if File.exist?(VAGRANT_ROOT+"/vagrant/settings.yml")
  USER_SETTINGS = YAML.load_file("#{VAGRANT_ROOT}/vagrant/settings.yml")

  if (not SETTINGS.empty?) || (not USER_SETTINGS.empty?)
    SETTINGS.deep_merge!(USER_SETTINGS)
  end
else
  abort "WARNING! Before running the machine you should create copy of #{VAGRANT_ROOT}/vagrant/settings.example.yml  and put in #{VAGRANT_ROOT}/vagrant folder with settings.yml name."
end

VAGRANTFILE_API_VERSION = "2"

OS_BOX = SETTINGS['VAGRANT']['BOX']

# Official OS name. used for locate correspond scripts for operation system
OS_NAME =  SETTINGS['VAGRANT']['OS']

MACHINE_IP = SETTINGS['VAGRANT']['IP']
MACHINE_CPU = SETTINGS['VAGRANT']['CPU']
MACHINE_MEMORY = SETTINGS['VAGRANT']['MEMORY']

MACHINE_HOSTNAME = SETTINGS['SITES']['BASE_DOMAIN']
BASE_DOMAIN = "vagrant"

required_plugins = %w( vagrant-hostmanager vagrant-vbguest )

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
  if File.directory?(File.expand_path("./vagrant"))
    config.vm.synced_folder "./vagrant", "/vagrant", type: "virtualbox"
  else
      puts "WARNING! ./vagrant folder does not exist!"
  end
  if File.directory?(File.expand_path("./data"))
    config.vm.synced_folder "./data", "/vagrant_data", type: "virtualbox"
  else
      puts "WARNING! ./data folder does not exist!"
  end

  if File.directory?(File.expand_path("./src"))
      config.vm.synced_folder "./src", "/var/www/", type: "virtualbox",
        owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=755,fmode=664"]
  else
    puts "WARNING! ./src folder does not exist!"
  end

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

  config.vm.define MACHINE_HOSTNAME + "." + BASE_DOMAIN do |machine|
    machine.vm.hostname = MACHINE_HOSTNAME

    machine.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true

      # Customize the count of cpus on the VM:
      vb.cpus = MACHINE_CPU

      # Customize the amount of memory on the VM:
      vb.memory = MACHINE_MEMORY

      # Vagrant Machine Name
      vb.name = MACHINE_HOSTNAME + "." + BASE_DOMAIN

      vb.customize ["modifyvm", :id, "--memory", MACHINE_MEMORY]
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
    hosts_arr = ["www.#{MACHINE_HOSTNAME}"]

    for i in 1..SETTINGS['SITES']['COUNT']
      cur_site_domain = SETTINGS['SITES']["SITE_#{i}"]['DOMAIN']

      bash_var = cur_site_domain.to_enum(:scan, /\W{2}\w+\W{1}/).map { Regexp.last_match }

      bash_var.each do |tmp|
        bash_var_arr = tmp[0][2..-2].split('__')
        bash_var_val = SETTINGS

        bash_var_arr.each do |i|
            bash_var_val = bash_var_val["#{i}"]
        end

        cur_site_domain.sub!(tmp.to_s, bash_var_val)
      end

      if cur_site_domain != MACHINE_HOSTNAME
          hosts_arr.push(cur_site_domain)
          hosts_arr.push("www.#{cur_site_domain}")
      end
    end

    if SETTINGS['PACKAGES']['PHPMYADMIN']
      hosts_arr.push("pma.#{MACHINE_HOSTNAME}")
    end

    if SETTINGS['PACKAGES']['MAILHOG']
      hosts_arr.push("mailhog.#{MACHINE_HOSTNAME}")
    end

    if SETTINGS['PACKAGES']['MAILCATCHER']
      hosts_arr.push("mailcatcher.#{MACHINE_HOSTNAME}")
    end

    config.hostmanager.aliases = hosts_arr
  else
    abort "ERROR! Vagrant plugin vagrant-hostmanager is not installed!"
  end
end
