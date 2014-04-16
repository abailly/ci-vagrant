#!/bin/sh
# install and configure jenkins

PROXY=$1

if [ z$PROXY != "z" ]; then
    export http_proxy=$PROXY
    export https_proxy=$PROXY
fi

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

sudo -u ciadmin mkdir /home/ciadmin/jenkins

sudo sed -i -e'/JENKINS_HOME=/c\JENKINS_HOME="/home/ciadmin/jenkins"' \
 -e '/JENKINS_JAVA_OPTIONS=/c\JENKINS_JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=true"' \
 -e '/JENKINS_USER=/c\JENKINS_USER="ciadmin"' \
 -e '/JENKINS_PORT=/c\JENKINS_PORT="8081"' /etc/sysconfig/jenkins

# log file is hardwired but user ciadmin probably has not access to /var/log hence 
# this prevents to start jenkins without any obvious reason
sudo sed -i -e 's|--logfile=/var/log/jenkins/jenkins.log|--logfile=/home/ciadmin/jenkins/jenkins.log|g' /etc/init.d/jenkins
sudo service jenkins start
sudo chkconfig jenkins on
