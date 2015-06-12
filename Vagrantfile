# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
vconfig = YAML.load_file "vagrant_config.yml"

box_hostname = vconfig['boxconfig']['name']
box_ip = vconfig['boxconfig']['ip']
box_ram = vconfig['boxconfig']['ram']
box_www_projects = vconfig['boxconfig']['www_projects']


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = box_hostname
  config.vm.network "private_network", ip: box_ip

  config.vm.provider "virtualbox" do |v|
      v.name = box_hostname
      v.memory = box_ram
  end

  config.vm.synced_folder box_www_projects, "/var/www/html",
  owner: "vagrant",
  group: "www-data",
  mount_options: ["dmode=775,fmode=664"]

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
  end 

end