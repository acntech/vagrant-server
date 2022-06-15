# AcnTech Ubuntu Server
AcnTech Ubuntu Server box based on Ubuntu Server 22.04 64-bit installed on a 100 GB disk.

Created with Vagrant 2.2.19 and VirtualBox 6.1.30.

It has provisioning for typical platform software such as Docker, Kubernetes (Minikube), etc.

### Usage
See box on Vagrant Cloud: [acntech/ubuntu-server](https://app.vagrantup.com/acntech/boxes/ubuntu-server).

See code on GitHub: [acntech/vagrant-server](https://github.com/acntech/vagrant-server).

Create a ```Vagrantfile``` with the following content inside an empty folder:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-server"
end
```

Start the box by issuing the following command from the command line inside the folder:
```
vagrant up
```

#### Customizations
The box can be customized further by setting VM name, CPU count, memory size and other parameters in the `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-server"

  config.vm.provider "virtualbox" do |vb|
    # Name to display in VirtualBox
    vb.name = "AcnTech Ubuntu Server Custom"
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize CPU count
    vb.cpus = "2"
    # Customize the amount of memory
    vb.memory = "2048"
    # Customize amount of video memory
    vb.customize ["modifyvm", :id, "--vram", "128"]
    # Disable 3D acceleration
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
  end
end
```
See more details on the [Vagrant homepage](https://www.vagrantup.com/docs/vagrantfile).

#### Keyboard language and layout
The box is default setup to use `us` keyboard layout. To change this you can do it by adding the following `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-server"
  config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive localectl set-keymap <keymap>"
end
```
The `<keymap>` is typically a country code. See more details on this [wiki page](https://wiki.archlinux.org/index.php/Linux_console/Keyboard_configuration).

#### Provisioning
Provisioning is done using the preinstalled Puppet agent. The GitHub repository has a set of modules that can be provisoned to install server software.

You can clone or download the repository and modify the `Vagrantfile` that is in the `ubuntu` directory of the repository.

There are two Puppet environments:
* `docker`: Installs the Docker Engine and the Docker Compose Plugin.
* `kubernetes`: Installs the Minikube distribution of the Kubernetes platform, in addition to the Docker Engine and the Docker Compose Plugin.

A Puppet environment can be provisoned by adding the following to your `Vagrantfile`:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-server"

  # Enable provisioning with puppet
  config.vm.provision "puppet" do |puppet|
    puppet.environment = "docker"
    puppet.environment_path = "../provision/puppet/environments"
    puppet.module_path = "../provision/puppet/modules"
  end
end
```

| :warning: **You should restart the box after provisioning, e.g. by using the commands** `vagrant halt` **then** `vagrant up`**.** |
| --- |
