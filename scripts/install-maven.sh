#!/bin/sh
# install and configure maven

PROXY=$1

if [ z$PROXY != "z" ]; then
    export http_proxy=$PROXY
    export https_proxy=$PROXY
fi

sudo wget -O /opt/maven.tar.gz -nv http://wwwftp.ciril.fr/pub/apache/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
sudo tar xzf /opt/maven.tar.gz -C /opt

sudo cat > /etc/profile.d/maven.sh <<EOF
[ -f /opt/apache-maven-3.2.1/bin/mvn ] && export PATH=$PATH:/opt/apache-maven-3.2.1/bin
EOF

cat > ~/.mavenrc <<EOF
export MAVEN_OPTS="-XX:MaxPermSize=256M"
EOF

sudo chmod +x /etc/profile.d/maven.sh
