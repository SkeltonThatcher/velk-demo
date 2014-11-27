velk-demo
=========

Vagrant deployed ELK (elasticsearch, logstash and kibana) demonstrator.

Guidance
--------

Install the latest VirtualBox, and Vagrant, this should be easy, ymmv.

1. Create a directory under which to keep vagrant configs.

2. Clone the repo to the previously created directory using "git clone https://github.com/SkeltonThatcher/velk-demo.git"

  (There may be also an in-dev version of the repo at "https://github.com/robthatcher/velk-demo")

3. The bootstrap.sh script will default to caching required binary packages locally on first run inside the 'packages' directory, allowing you to subsequently run the demostrator offline, i.e. without network access. If you want to repeat the demo, as long as the 'packages' directory is in place no additional downloads will be required.
	
4. If you want to install directly from the the internnet, manually remove the 'packages' directory, all required packages will be pulled in live via your internet connection. 

5. If you didn't already, start the machine by using, 'vagrant up' in the directory.

6. Sit back for a few minutes depending on your net connection speed (fingers crossed), or machine speed if using offline mode.

Notes
-----

A successful build (i.e. deployment and provision) resutlts in being able browse kibana and elasticsearch web interfaces.

The setup captures local syslog, messages from the logmessagegenerator.sh script and nginx logs (from the vm), meaning using the webui creates new log entries which then show up in the ELK interface.

If you need the 'packages' repo, it can cloned from github, see - http://github.com/robthatcher/velk-demo-packages.git 

	Logging into the VM

	1. Credentials to login the box - login : vagrant , password : vagrant
	2. Login method 1 : vagrant ssh
	3. Login method 2 : ssh -p 2222 vagrant@localhost

	Access the platform using the following URLs

        	Elasticsearch GUI : http://localhost:9200/_plugin/kopf/
        	ELK GUI : http://yourinternal.virtualbox.ip/

N.B. You may have to login to the box to check the IP address of the interface which is serving ELK.

Credits
-------
Numerous internet resources were used in creating this demonstrator...

