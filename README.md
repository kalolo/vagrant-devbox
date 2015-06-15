# vagrant-devbox

## Installation

- Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads) as vm provider
- Install [Vagrant](http://docs.vagrantup.com/v2/installation/)

Then on the terminal
    
    $ git clone https://github.com/kalolo/vagrant-devbox
    $ cd vagrant-devbox
    $ brew install ansible
    $ vagrant plugin install vagrant-hostsupdater

Edit vagrant_config.yml and set your information

    boxconfig:
      name: <custom-box-name>
      box: <vagrant os box to use>
      ram: <ram>
      ip: <ip>
      www_projects: "<path where projects are located>"

## Usage

Bring up your box

    $ vagrant up

To setup your own custom vhost, just create an apache vhost conf and put it on templates/vhosts/ as a .conf file, and you will need to reload provisions


    $ vagrant provision
