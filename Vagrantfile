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
hostnames = Array.new

macrovhost = ""

Dir.foreach(box_www_projects) do |item|
    next if item.start_with?(".")
    host = item.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "." + box_hostname
    hostnames.push host
    macrovhost += "Use VHost " + host + " 80 /var/www/html/" + item + " \n"
end

File.open("templates/vhosts/macrovhosts.conf", 'w') { |file| file.write(macrovhost) }

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = box_hostname
  config.vm.network "private_network", ip: box_ip
  config.hostsupdater.aliases = hostnames

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