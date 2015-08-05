# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require_relative 'lib/webprojects'

vconfig = YAML.load_file "conf/vagrant_config.yml"

box_hostname = vconfig['boxconfig']['name']
box_ip       = vconfig['boxconfig']['ip']
box_ram      = vconfig['boxconfig']['ram']
box_os       = vconfig['boxconfig']['box']
webProjects  = WebProjects.new(vconfig['boxconfig']['apache_projects'], box_hostname)


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = box_os
  config.vm.hostname = box_hostname
  config.vm.network "private_network", ip: box_ip
  config.hostsupdater.aliases = webProjects.hostnames
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |v|
      v.name = box_hostname
      v.memory = box_ram
  end

  webProjects.syncedFolders.each do |folder| 
      config.vm.synced_folder folder[:path], "/var/www/html/" + folder[:name],
      owner: "vagrant",
      group: "www-data",
      mount_options: ["dmode=775,fmode=664"]
  end

  webProjects.writeMacroHosts("templates/vhosts/macrovhosts.conf")

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "app/playbook.yml"
  end

end
