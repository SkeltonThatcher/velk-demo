velk-demo
=========

Vagrant deployed ELK (elasticsearch, logstash and kibana) demonstrator.

Guidance

Install the latest VirtualBox, and Vagrant, this should be easy, ymmv.

1. Create a directory under which to keep vagrant configs.
2. Clone this repo to the previously created directory using "git clone https://github.com/robthatcher/velk-demo.git"
3. Performing a "Vagrant Up" will begin provisioning the machine, and will default to caching required binary packages locally inside the 'packages' directory, allowing you to run offline, i.e. without network access subsequently if you want to repeat the demo.
	
4. Alteratively you could clone the repo for holding the packages which is here https://github.com/robthatcher/velk-demo-packages.git 

5. If you didn't already, start the machine by using, 'vagrant up' in the directory.

Sit back for a few minutes depending on your net connection speed (fingers crossed), or machine speed if using offline mode.

A successful build (i.e. deployment and provision) resutlts in being able browse kibana and elasticsearch, 
the setup captures local syslog, messages from the logmessagegenerator.sh script and nginx logs (from the vm), meaning using the webui creates new logging.

Notes

1. Credentials to login the box - login : vagrant , password : vagrant
2. Login method 1 : vagrant ssh
3. Login method 2 : ssh -p 2222 vagrant@localhost

Access the platform using the following URLs

        Elasticsearch check http://localhost:9200/_plugin/kopf/
        ELK GUI check : http://yourinternal.virtualbox.ip/

N.B. You may have to login to the box to check the IP address of the interface which is serving ELK.

Credits

Numerous internet resources were used in creating this demonstrator...

