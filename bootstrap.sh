#!/usr/bin/env bash 
#
# If you want to install latest packages over network, rename or remove the 'packages' directory.

if [ -d /vagrant/packages ] ; then

	if [ ! -e /vagrant/packages/.remoterepotrue ] ; then

		echo "VELK: Packages repo needs first time download"
		# if git exists on machine git clone repo in packages dir {TBD}  else pull in static tar ball via wget
		cd /vagrant/packages/
		wget https://github.com/robthatcher/velk-demo-packages/raw/master/tarballs/velk-ek-packages.tar.gz
		wget https://github.com/robthatcher/velk-demo-packages/raw/master/tarballs/velk-java-packages.tar.gz
		wget https://github.com/robthatcher/velk-demo-packages/raw/master/tarballs/velk-logstash-packages.tar.gz
		tar -xf velk-ek-packages.tar.gz 
		tar -xf velk-java-packages.tar.gz 
		tar -xf velk-logstash-packages.tar.gz 
		touch /vagrant/packages/.remoterepotrue
	else
		echo "VELK: Offline install support already present, beginning install and configuration"
	fi

	######## START Local install branch

	echo -e "VELK: Locally cached install triggered\n"

	# Add Elasticsearch key to apt 
	apt-key add /vagrant/data/GPG-KEY-elasticsearch
	echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
	echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
	echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list

	# Install local java 
	echo "VELK: Installing local Java and Nginx"
	dpkg -i /vagrant/packages/install-java/*.deb
	
	# Install local elasticsearch  
	echo "VELK: Installing local Elasticsearch"
	dpkg -i /vagrant/packages/install-elasticsearch-kibana/*.deb

	# Install local logstash 
	echo "VELK: Installing local Logstash and Logstash forwarder"
	dpkg -i /vagrant/packages/install-logstash/*.deb

	# Install local logstash forwarder init script
	echo "VELK: Installing local Logstash init script"
	cd /etc/init.d/ 
	sudo cp /vagrant/scripts/logstash-forwarder.init logstash-forwarder 
	sudo chmod +x logstash-forwarder 
	sudo update-rc.d logstash-forwarder defaults 
	sudo service elasticsearch start 

	# Install local copy of kibana
	echo "VELK: Installing local Kibana"
	sudo tar zxf /vagrant/packages/install-elasticsearch-kibana/kibana-3.1.0.tar.gz -C /usr/share/
	sudo ln -s /usr/share/kibana-3.1.0/ /usr/share/kibana3
	sleep 1
	sudo sed -i 's/hostname+":9200/hostname+":80/' /usr/share/kibana3/config.js 

	# Install one of Kopf or Head elasticsearch plugins

	#sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
	#sudo /usr/share/elasticsearch/bin/plugin -install lmenzes/elasticsearch-kopf
	#Use local copy of kopf
	#--url file:///path/to/plugin --install plugin-name

	echo "VELK: Installng local kopf plugin"
	sudo /usr/share/elasticsearch/bin/plugin -u file:///vagrant/packages/install-elasticsearch-kibana/elasticsearch-kopf.zip --install lmenzes/elasticsearch-kopf

	######## END local install branch
else
	######## START Net install branch

	echo "VELK: Net install beginning"
	echo -e "Sleeping for 10 seconds - ctrl-c to abort\n"
	sleep 10

	# Add Elasticsearch key to apt
	echo "VELK: Adding Elasticsearch key to package manager"
	wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
	echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
	echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
	echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | sudo tee /etc/apt/sources.list.d/logstashforwarder.list

	# Update apt 
	echo "VELK: Updating package manager"
	sudo apt-get update 

	# Install java & nginx
	echo "VELK: Installing java, nginx and depedencies"
	sudo apt-get install openjdk-7-jre-headless nginx apache2-utils -y 

	# Install elasticsearch and logstash
	echo "VELK: Installing Elasticsearch, Logstash and forwarder"
	sudo apt-get install elasticsearch logstash logstash-forwarder -y 

	# Configure logstash forwarder 
	echo "VELK: Configuring Logstash forwarder"
	cd /etc/init.d/
	sudo wget https://raw.githubusercontent.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder
	sudo chmod +x logstash-forwarder 
	sudo update-rc.d logstash-forwarder defaults 
	sudo service elasticsearch start 

	# Install Kibana 
	echo "VELK: Installing Kibana"
	cd ~ 
	wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
	tar zxvf kibana-3.1.0.tar.gz 
	sudo mv kibana-3.1.0 /usr/share/kibana3 
	sudo sed -i 's/hostname+":9200/hostname+":80/' /usr/share/kibana3/config.js 

	# Install one of Kopf or Head elasticsearch plugins
	echo "VELK: Installing kopf elasticsearch plugin"
	#sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
	sudo /usr/share/elasticsearch/bin/plugin -install lmenzes/elasticsearch-kopf

	######## END Net install branch

fi

######## Local configuration of components.############

# Configure Nginx
#This frequently fails to connect over so I've mvoed the file to the repo, and copy if via local filesystem, install steps retained for ref.
#wget https://github.com/elasticsearch/kibana/raw/master/sample/nginx.conf 
#sudo cp nginx.conf /etc/nginx/sites-available/default

echo "VELK: Installing local Nginx.conf"
sudo cp /vagrant/conf/vELK-nginx.conf /etc/nginx/sites-available/default 
sudo service nginx restart 

# Make logstash dash default
echo "VELK: Setting default kibana dashboard"
sudo cp /usr/share/kibana3/app/dashboards/logstash.json /usr/share/kibana3/app/dashboards/default.json

# Make elasticsearch start on startup-boot
echo "VELK: Enable Elasticsearch start on boot"
sudo update-rc.d elasticsearch defaults 95 10

# Change timezone to Europe/London
echo "VELK: Setting Timezone to Europe/London"
echo "Europe/Dublin" > /etc/timezone    
dpkg-reconfigure -f noninteractive tzdata

####### Setup demo #########

# If you want to Start up a logstash pipeline which outputs to kibana, use the following command line 
# $ /opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'

#sudo echo "/opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { host => localhost } }'" > /root/lstmsg
#sudo chmod +x /root/lstmsg

# Add some sample events to ELK to provide a few days historical back entries
#sudo cp /vagrant/data/access.log /tmp
#sudo cp /vagrant/conf/logstash-nginx.conf /tmp
#sudo /opt/logstash/bin/logstash -f /tmp/logstash-nginx.conf &

# Add a logmessagegenerator script and fire it up
sudo cp /vagrant/scripts/logmessagegenerator.sh /tmp
sudo chmod +x /tmp/logmessagegenerator.sh
sudo /tmp/logmessagegenerator.sh &

# Add config to listen to own syslog and nginx files
sudo cp /vagrant/conf/logstash.conf /etc/logstash/conf.d/
sudo /opt/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf &

echo "VELK: Point a web browser at http://localhost:9200/_plugin/kopf/ to see elasticsearch running"
echo ""
echo "VELK: The gui is located at http://172.28.... something, use 'vagrant ssh' to login to the vm and check"
