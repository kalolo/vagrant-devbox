# vagrant-devbox

## Installation

    $ vagrant plugin install vagrant-hostsupdater

Edit vagrant_config.yml and set your information

    boxconfig:
      name: <custom-box-name>
      box: <vagrant os box to use>
      ram: <ram>
      ip: <ip>
      www_projects: "<path where projects are located>"

Bring up your box

    $ vagrant up


## Usage

To setup your own custom vhost, just create an apache vhost conf and put it on templates/vhosts/ as a .conf file, and you will need to reload provisions


    $ vagrant reload --provision