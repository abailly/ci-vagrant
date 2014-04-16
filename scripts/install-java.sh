#!/bin/sh
# install a JDK 6 for 32 and 64 bits
# see http://stackoverflow.com/questions/10268583/how-to-automate-download-and-instalation-of-java-jdk-on-linux

PROXY=$1

if [ z$PROXY != "z" ]; then
    export http_proxy=$PROXY
    export https_proxy=$PROXY
fi

sudo yum install -y wget git

# first jdk64 as default jdk
JDK64_LOCATION=/opt/jdk-6u45-linux-x64.bin

echo "installing jdk 64 bit in $JDK64_LOCATION"

[ -f $JDK64_LOCATION ] || wget -nv -O $JDK64_LOCATION --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin

sudo chmod +x $JDK64_LOCATION

[ -d /usr/java ] || sudo mkdir -p /usr/java

PWD=$(pwd)

cd /usr/java

$JDK64_LOCATION

cd $PWD

sudo mv /usr/java/jdk1.6.0_45 /usr/java/jdk1.6.0_45-x64

# then install jdk32
JDK32_LOCATION=/opt/jdk-6u45-linux-i586.bin
echo "installing jdk 32 bit in $JDK32_LOCATION"

# install 32bits libc
sudo yum -y upgrade libstdc++
sudo yum -y install glibc.i686 
sudo yum -y install libstdc++.i686

[ -f $JDK32_LOCATION ] || wget -nv -O $JDK32_LOCATION --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin
sudo chmod +x $JDK32_LOCATION

PWD=$(pwd)

cd /usr/java

$JDK32_LOCATION

cd $PWD

sudo cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=/usr/java/jdk1.6.0_45-x64
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

sudo chmod +x /etc/profile.d/java.sh
