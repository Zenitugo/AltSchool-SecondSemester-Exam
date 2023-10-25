# PROJECT SOLUTION 

## About Vagrant.sh
To automate the provisioning of two systems I created a bash script called **vagrant.sh**.
In this script I started by initialising vagrant with the command called `vagrant init`

I configured the VMs in the script, declaring hostname, ip address, base box and some packages to provision while the machine is trying to spin up.

I gave a command for the script to `cat` these configyrations into the **Vagrantfile** that was initialised.


I gave an instruction for the scripts to carry out the following commands:  `vagrant up` and `vagrant ssh master`

## About Master-deploy.sh and Slave-deploy.sh
**This is a script that contains:**
- The commands to automate the deployment of LAMP STACK on the master machine. This involved:
    
    1. Updating Apt Package Manager.
    2. Installing Apache.
        - Ensuring Apache is set to start at boot
        - Configuring firewall
    3. Installing MySQL
        - Ensuring mysql starts and its enabled to run on system boot.
        - Securing mysql installation.
    4. Installing PHP with ppa:ondre
        This was done by first installing `software-properties-common`
    
- To clone the repository I needed to configure Apache and php first. This involved:

    1. Configuring PHP
        - Restarting the Apache2 webserver
        - Installing composer using `curl`
        - Moving the composer binary to the system directory.
    2. Configuring Apache
        - Appending the virtual host to the `/var/www/html/laravel` directory.
        - Enabling apache rewrite modules
        - Enabling laravel site
        - Dissabling apache 000-default site.
    3. Installing Laravel repository
        - creating a directory where the application will be cloned.
        - Giving Apache the ownership of the directory `/var/www/html/laravel`
        - Install git 
        - Cloning the repository from git hub.
        - Give Apache permissions over the directory.
        - Create the .env file.
        - Copy the contents from `.env.example` to `.env` file
        - Set up the encryption key
    4. Create MYSQL database
        - Declare my database credentials.
        - Set up `zenitugo` database.
    5. Update some environmental variables in the .env file
          Variables like database password, database username and database name were changed.
    6. Cache the Configuration.
    7. Migrate the server
    8. Restart apache 2.
 
The Master script is used to deploy LAMP stack on the master machine while the Slave script is used to deploy LAMP stack on the slave machine. The difference between the scripts is that the server name. Master-deploy.sh has the IP address for the Master VM and slave-deploy.sh has the IP address for the SlaveVM  

### PROOF OF DEPLOYMENT

![laravel app deployed on master](./Access%20to%20Laravel%20Application%20with%20Master%20VM.png)

Ip address of master: 192.168.33.10


## About Ansible
I created a directory called Ansible and in it I placed three files and a directory. The files were:

- Inventory/hosts file: this file contains the ip address, password for the master machine to act as a controller to target the slave VMs while running ansible-playbook.

- ansible.cfg: This file is meant to override the ansible configuration in the `/etc` directory. 

- playbbok.yml
The directory named roles contained one directory called `ssmtp` and  inside of it contained another two directories named `files` and `task`. The roles directory contained the configuration of ssmtp so that I could schedule cron jobs to check the server uptime.


## About Playbook.yml
The tasks carried out by the playbook are:
- Executing the bash script to deploy the Laravel application
- Verifying the application accessibility by giving a command to register the content of the application and report success when the word 'Laracast' is found
- Creating cron jobs to check the server uptime
- The playbook doesn't have sudo privileges `(become: yes)` because the bash scripts have commands with sudo privileges. This decision was taken because I was having issues executing my playbook. The command `composer install` does not approve giving sudo privileges to execute this command and if I must continue, I must type a 'YES' to approve the installation. The command does not allow a '-y' flag option so I removed `become:yes` from my playbook.


### PROOF OF DEPLOYMENT
![laravel app deployed on slave](./Access%20to%20Laravel%20Application%20with%20Slave%20VM.png) 

IP of Slave Machine: 192.168.33.11

### PROOF OF UPTIME SERVER
![cron jobs](./uptime%20log.png)
