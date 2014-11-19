velk-demo
=========

Vagrant deployed ELK (elasticsearch, logstash and kibana) demonstrator.

Guidance

Install the latest VirtualBox, and Vagrant, this should be easy, ymmv.

1. Create a directory under which to keep vagrant configs.
2. Clone this repo, we assume you know how to do this as you're on github reading this....
3. Add packages repo if you want to run in offline mode, i.e. no downloading from the internet for OS packages etc.
4. Start the machine, 'vagrant up' in the directory.

Sit back for a few minutes depending on your net connection speed (fingers crossed), or machine speed if using offline mode.

A successful build (i.e. deployment and provision) resutlts in being able browse kibana and elasticsearch, 
the setup captures local syslog, messages and nginx logs (from the vm)

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

