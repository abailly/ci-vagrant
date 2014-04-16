# 
# This Vagrant file (http://vagrantup.com) configures two CentOS VMs, one for dev only and the other
# for CI.
#
# The first VM, dev contains:
# - git
# - java 
# - maven
#
# To use, run
# > vagrant up dev
# > vagrant ssh dev
# > ...
#
# The second VM ci contains same software than dev plus:
# - postgresql
# - gerrit
# - jenkins 
#
# Ports 29418, 8080 and 8080 are forwarded locally to provide access respectively to 
# gerrit through ssh, gerrit web interface and jenkins web interface.
# 
# This file uses the http_proxy env variable to set proxy for retrieving software if set.

Vagrant.configure("2") do |config|

  config.vm.box = "CentOS-6.4-x86_64"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v0.1.0/centos64-x86_64-20131030.box"

  proxy = ENV['http_proxy']
  
  config.vm.provider :virtualbox do |vb|
     vb.memory = 2048

     # from http://superuser.com/questions/542709/vagrant-share-host-vpn-with-guest
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

     vb.customize ["modifyvm", :id, "--cpus", "4", "--ioapic", "on"]
  end

  # machine for building and developing
  config.vm.define :dev do |thevm|
    thevm.vm.hostname = "dev"

    thevm.vm.provision :shell, :path => "scripts/set-proxy.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-java.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-maven.sh", :args => proxy

    # remote debug on standard port via -Dmaven.surefire.debug
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 5005, host: 5005
  end

  config.vm.define :ci do |thevm|
    thevm.vm.hostname = "ci"

    # gerrit SSH access
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 29418, host: 29418
    # gerrit web port
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 8080, host: 8080
    # jenkins
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", guest: 8081, host: 8081

    thevm.vm.provision :shell, :path => "scripts/set-proxy.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-java.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-postgresql.sh", :args => proxy
    thevm.vm.provision :shell, :inline => "sudo su -l ciadmin /vagrant/scripts/install-gerrit.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-jenkins.sh", :args => proxy
    thevm.vm.provision :shell, :path => "scripts/install-maven.sh", :args => proxy
  end

end
