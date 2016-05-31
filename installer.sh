#!/bin/bash
echo -e "******** Installing TestAgent by UNIMI MILANO\n\n\n\n"
echo -e "\n\n ******** updating repository"
yum -y update
echo -e "\n\n******** gcc and python dependecies installation"
rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
yum -y install gcc python-devel
yum -y install python-pip
yum -y install libxslt-devel libxml2-devel python-lxml wget
yum -y install git
echo -e "\n\n******** rabbitmq-server installation and configuration\n\n"
yum -y install erlang
rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
yum -y install rabbitmq-server
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
sleep 15
rabbitmqctl add_user testManager testManager
rabbitmqctl set_permissions -p / testManager ".*" ".*" ".*"
echo -e "\n\n******** Installing Redis as backend\n\n"
yum -y install redis
systemctl enable redis
systemctl start redis
echo -e "\n\n******** Downloading test agent from git\n\n"
git clone https://github.com/SESARLab/mooncloud_ta.git
echo -e "\n\n******** Installing python dependecies\n\n" 
pip install --upgrade pip
pip2 install -r mooncloud_ta/requirements.txt
pip2 install kombu
pip2 install billiard
pip2 install python-daemon
pip2 install redis
pip2 install babel
pip2 install bs4
pip2 install lxml
echo -e "\n\n******** Setting up environment\n\n" 
mkdir /etc/testagent/
mkdir /etc/testagent/selfassesement
mkdir /var/log/testagent/
mkdir /var/log/testagent/evidences
chmod -r 600 /var/log/testagent
cp testagent.conf /etc/testagent/
cp subscription.conf /etc/testagent/
cp testagent.txt /usr/lib/systemd/system/testagent.service	
echo -e "\n\n******** Finalizing installation\n\n" 
cp probe.py ~/
cp test.xml ~/
cd mooncloud_ta
python setup.py install
systemctl start testagent

