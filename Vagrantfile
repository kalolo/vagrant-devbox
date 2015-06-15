# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
vconfig = YAML.load_file "conf/vagrant_config.yml"

box_hostname     = vconfig['boxconfig']['name']
box_ip           = vconfig['boxconfig']['ip']
box_ram          = vconfig['boxconfig']['ram']
box_os           = vconfig['boxconfig']['box']
box_www_projects = vconfig['boxconfig']['www_projects']

hostnames  = Array.new
synced_folders = Array.new
macrovhost = ""

Dir.foreach(box_www_projects) do |item|
    next if item.start_with?(".") || !File.directory?(box_www_projects + "/" + item)

    host = item.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "." + box_hostname
    hostnames.push host
    macrovhost += "Use VHost " + host + " 80 /var/www/html/" + item + " \n"

    real_path = box_www_projects + "/" + item

    if ( File.symlink?real_path) 
      real_path = File.readlink(real_path)
    end

    synced_folders.push({"name" => item, "path" => real_path})

end

File.open("templates/vhosts/macrovhosts.conf", 'w') { |file| file.write(macrovhost) }

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = box_os
  config.vm.hostname = box_hostname
  config.vm.network "private_network", ip: box_ip
  config.hostsupdater.aliases = hostnames

  config.vm.provider "virtualbox" do |v|
      v.name = box_hostname
      v.memory = box_ram
  end

  synced_folders.each do |folder| 
      config.vm.synced_folder folder['path'], "/var/www/html/" + folder['name'],
      owner: "vagrant",
      group: "www-data",
      mount_options: ["dmode=775,fmode=664"]
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "app/playbook.yml"
  end 

end