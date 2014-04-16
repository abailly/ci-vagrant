# CI Configuration

This project contains a bunch of scripts and configuration files that can be
used to build a full-fledged CI environment. It contains mainly a Vagrantfile 
for provisioning a two VMs running:

* java (32 and 64bits)
* maven
* postgresql
* gerrit 
* jenkins

From that base it should be easy to automate projects configuration using eg. JobDSL 
for Jenkins.
