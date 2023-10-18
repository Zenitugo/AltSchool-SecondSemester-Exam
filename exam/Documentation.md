# PROJECT TASK

## Objective:
- Automate the provisioning of two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant.

- On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack.

- This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL. 

- Ensure the bash script is reusable and readable.

- Using an Ansible playbook:
   1. Execute the bash script on the Slave node and verify that the PHP application is accessible through the VM’s IP address (take screenshot of this as evidence)
   2. Create a cron job to check the server’s uptime every 12 am.


## PHP Laravel GitHub Repository:

[LARAVEL REPOSITORY LINK](https://github.com/laravel/laravel)


## PROJECT SOLUTION 

### About Vagrant.sh
To automate the provisioning of two systems I created a bash script called **vagrant.sh**.
In this script I started by initialising vagrant with the command called `vagrant init`

I configured the VMs in the script, declaring hostname, ip address, base box and some packages to provision while the machine is trying to spin up.

I gave a command for the script to `cat` these configyrations into the **Vagrantfile** that was initialised.


I gave an instruction for the scripts to carry out the following commands:  `vagrant up slave`, `vagrant up master` and `vagrant ssh master`

### About Master-deploy.sh
**This is a script that contains:**
- The commands to automate the deployment of LAMP STACK on the master machine. This involved:
    
    1. Updating Apt Package Manager.
    2. Installing Apache.
        - Ensuring apache is set to start at boot
        - Configuring firewall
    3. Installing MySQL
        - Ensuring mysql starts and its enabled to run on system boot.
        - Securing mysql installation.
    4. Installing PHP with ppa:ondre
        This was done by first installing `software-properties-common`
    
- To clone the repository I needed to configure apache and php first. This involved:

    1. Configuring PHP
        - Restarting apache2 webserver
        - Installing composer using `curl`
        - Moving the composer binary to the system directory.
    2. Configuring Apache
        - Appending the virtual host to the `/var/www/html/laravel` directory.
        - Enabling apache rewrite modules
        - Enabling laravel site
        - Dissabling apache 000-default site.
    3. Installing Laravel repository
        - creating a directory where the application will be cloned.
        - Giving apache the ownership of the directory `/var/www/html/laravel`
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


## About Ansible

 