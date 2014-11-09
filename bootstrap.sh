#!/usr/bin/env bash 
#
if [ -d /vagrant/packages ] ; then

######## START Local install branch

echo -e "Locally cached install triggered\n"

# Add Elasticsearch key to apt
apt-key add /vagrant/packages/GPG-KEY-elasticsearch
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list

# Install java 
echo "Installing Java and Nginx"
# Install elasticsearch and logstash
dpkg -i /vagrant/packages/install-java/*.deb
echo "Installing Elasticsearch and Logstash"
dpkg -i /vagrant/packages/install-elasticsearch-logstash/*.deb

# Configure logstash forwarder 
# Use local copy of init script.
echo "Local logstash init script, installing"
cd /etc/init.d/ 
sudo cp /vagrant/packages/logstash-forwarder.init logstash-forwarder 
sudo chmod +x logstash-forwarder 
sudo update-rc.d logstash-forwarder defaults 
sudo service elasticsearch start 

# Use local copy of kibana
echo "Local Kibana found, installing"
sudo tar zxf /vagrant/packages/kibana-3.1.0.tar.gz -C /usr/share/
sudo ln -s /usr/share/kibana-3.1.0/ /usr/share/kibana3
sleep 1
sudo sed -i 's/hostname+":9200/hostname+":80/' /usr/share/kibana3/config.js 

# install head or kopf

#sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
#sudo /usr/share/elasticsearch/bin/plugin -install lmenzes/elasticsearch-kopf
#Use local copy of kopf
#--url file:///path/to/plugin --install plugin-name
echo "Local kopf found, installing"
sudo /usr/share/elasticsearch/bin/plugin -u file:///vagrant/packages/elasticsearch-kopf.zip --install lmenzes/elasticsearch-kopf

######## END local install branch

else

######## START Net install branch

echo "Net install beginning"
echo -e "Sleeping for 10 seconds - ctrl-c to abort\n"
sleep 10

# Add Elasticsearch key to apt
#wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
#echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
#echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
#echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list

# Update apt 
#sudo apt-get update 

# Install java & nginx
#sudo apt-get install openjdk-7-jre-headless nginx apache2-utils -y 

# Install elasticsearch and logstash
#sudo apt-get install elasticsearch logstash logstash-forwarder -y 

# Configure logstash forwarder 
#cd /etc/init.d/
#sudo wget https://raw.githubusercontent.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder
#sudo chmod +x logstash-forwarder 
#sudo update-rc.d logstash-forwarder defaults 
#sudo service elasticsearch start 

# Install Kibana 
#cd ~ 
#wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
sudo sed -i 's/hostname+":9200/hostname+":80/' /usr/share/kibana3/config.js 

# Install Kopf plugin
#sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
#sudo /usr/share/elasticsearch/bin/plugin -install lmenzes/elasticsearch-kopf

fi

######## END Net install branch

# Configure Nginx
#wget https://github.com/elasticsearch/kibana/raw/master/sample/nginx.conf # This sometimes fails to connect over ssl file stored in repo
#sudo cp nginx.conf /etc/nginx/sites-available/default  # this fails in provisioning for some possible ssl related reason, copied file locally and push it in.
echo "Local Nginx.conf found, installing"
sudo cp /vagrant/vELK-nginx.conf /etc/nginx/sites-available/default 
sudo service nginx restart 

# Make logstash dash default
sudo cp /usr/share/kibana3/app/dashboards/logstash.json /usr/share/kibana3/app/dashboards/default.json

# Make elasticsearch start on startup-boot
sudo update-rc.d elasticsearch defaults 95 10

# Change timezone to Europe/London
echo "Europe/Dublin" > /etc/timezone    
dpkg-reconfigure -f noninteractive tzdata

####### Setup demo

# If you want to Start up a logstash pipeline which outputs to kibana, use the following command line 
# $ /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'

#sudo echo "/opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'" > /root/lstmsg
#sudo chmod +x /root/lstmsg

# Add some sample events to ELK to provide a few days historical back entries
#sudo cp /vagrant/access.log /tmp
#sudo cp /vagrant/logstash-nginx.conf /tmp
#sudo /opt/logstash/bin/logstash -f /tmp/logstash-nginx.conf &

# Add a logmessagegenerator script and fire it up
sudo cp /vagrant/logmessagegenerator.sh /tmp
sudo chmod +x /tmp/logmessagegenerator.sh
sudo /tmp/logmessagegenerator.sh &

# Add config to listen to own syslog and nginx files
sudo cp /vagrant/logstash.conf /etc/logstash/conf.d/
sudo /opt/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf &
