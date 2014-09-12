#!/usr/bin/env bash 

wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - 
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list 
echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list 
echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list 

# update apt 

sudo apt-get update 

# install java 

sudo apt-get install openjdk-7-jre-headless nginx apache2-utils -y 
sudo apt-get install elasticsearch logstash logstash-forwarder -y 

# Configure logstash forwarder 

cd /etc/init.d/ 
sudo wget https://raw.github.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder 
sudo chmod +x logstash-forwarder 
sudo update-rc.d logstash-forwarder defaults 
sudo service elasticsearch start 

# install head or kopf

#sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head 
sudo /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

# Install Kibana 

cd ~ 
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
tar zxvf kibana-3.1.0.tar.gz 
sudo mv kibana-3.1.0 /usr/share/kibana3 
sudo sed -i 's/hostname+":9200/hostname+":80/' /usr/share/kibana3/config.js 

#wget https://github.com/elasticsearch/kibana/raw/master/sample/nginx.conf # This sometimes fails to connect over ssl file stored in repo
#sudo cp nginx.conf /etc/nginx/sites-available/default  # this fails in provisioning for some possible ssl related reason, copied file locally and push it in.

sudo cp /vagrant/vELK-nginx.conf /etc/nginx/sites-available/default 
sudo service nginx restart 

# Make logstash dash default

sudo cp /usr/share/kibana3/app/dashboards/logstash.json /usr/share/kibana3/app/dashboards/default.json

# Make elasticsearch start on startup-boot

sudo update-rc.d elasticsearch defaults 95 10

# Basic demo

# Start up a logstash pipeline which outputs to kibana -- /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'

sudo echo "/opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'" > /root/lstmsg
sudo chmod +x /root/lstmsg


# Add some sample events to ELK to provide a few days historical back entries

sudo cp /vagrant/access.log /tmp
sudo cp /vagrant/logstash-nginx.conf /tmp
sudo /opt/logstash/bin/logstash -f /tmp/logstash-nginx.conf &

# Add config to listen to own syslog and nginx files

sudo cp /vagrant/logstash.conf /etc/logstash/conf.d/
sudo /opt/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf &
