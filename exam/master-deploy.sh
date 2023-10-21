#!/bin/bash

#APACHE CONFIGURATION
#Update Apt Package manager
    echo -e "\n\nUpdating Apt Package\n"
    sudo apt-get update -y
    sudo apt-get upgrade -y

#Installing Apache
    sudo apt-get install apache2 -y

#To Ensure Apache is running and set to start on boot.
    echo -e "\n\nStarting Apache\n"
    sudo systemctl start apache2
    echo -e "\n\nEnabling Apache to start on boot\n"
    sudo systemctl enable apache2

#To cofigure firewall rule
    echo -e "\n\nAdding firewall rule to Apache\n"
    sudo ufw allow 80/tcp


#MYSQL CONFIGURATION
#Update Apt Package Manager
    echo -e "\n\nUpdating Apt Package\n"
    sudo apt-get update -y

#Installing MySQL
    echo -e "\n\nInstalling MySQL\n"
    sudo apt-get install mysql-server -y

#Start and enable MySQL to start and enable to run on system boot
    sudo systemctl start mysql
    sudo systemctl enable mysql

#Secure MySQL Installation
    sudo mysql_secure_installation<<EOF
         n
         n
         n
         n
         y
EOF


#INSTALLING PHP USING PPA:ONDRE
#Installing PHP using the ppa:ondrej/php package repo.
    sudo apt-get install software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y     

#CONFIGURATION OF PHP
    sudo sed -i 's/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
    #After configuring PHP we need to restart apache
    sudo systemctl restart apache2
    #Install composer since it is a php dependency manager that manages the dependencies and libraries that PHP applications require
    curl -sS https://getcomposer.org/installer | php
    #Move the downloaded binary to the system directory
    sudo mv composer.phar /usr/local/bin/composer
    
#CONFIGURATION OF APACHE WEB SERVER
    sudo tee -a  /etc/apache2/sites-available/laravel.conf<<EOF
        <VirtualHost *:80>

             ServerAdmin ugochiukaegbu19@gmail.com
             ServerName 192.168.33.10
             DocumentRoot /var/www/html/laravel/public

             <Directory /var/www/html/laravel/public>
                Options Indexes Multiviews FollowSymlinks
                AllowOverride All
                Require all granted
             </Directory>

             ErrorLog ${APACHE_LOG_DIR}/error.log
             CustomLog ${APACHE_LOG_DIR}/access.log combined
         </VirtualHost>
EOF

#Activate the Apache rewrite module using the following command
    echo -e "\n\nEnabling Modules\n"
    sudo a2enmod rewrite
    echo -e "\n\nEnabling Laravel virtual host"
    sudo a2ensite laravel
    echo -e "\n\nDissabling Apache default host"
    sudo a2dissite 000-default

#Restart Apache
    sudo systemctl restart apache2

#INSTALLING LARAVEL
#Create the folder that will hold the application
    sudo mkdir /var/www/html/laravel && cd /var/www/html/laravel
    sudo chown -R www-data:www-data /var/www/html/laravel
#Clone the laravel application
    sudo apt-get update
    sudo apt-get install git composer -y
    sudo -u www-data git clone https://github.com/laravel/laravel.git /var/www/html/laravel
    sudo chown -R $USER /var/www/html/laravel
    cd /var/www/html/laravel
    composer install --no-dev

#Give apache permissions over the laravel directory
   sudo chown -R www-data:www-data  /var/www/html/laravel
   sudo chown -R www-data:www-data /var/www
   sudo chmod -R 775 /var/www/html/laravel
   sudo chmod -R 777 /var/www/html/laravel/storage/*
   sudo chmod -R 777 /var/www/html/laravel/bootstrap/*
   sudo chmod -R 777 www-data:www-data  /var/www/html/laravel/bootstrap/cache

#Update ENV File and Generate An Encryption Key
   sudo touch /var/www/html/laravel/.env
   sudo cp .env.example .env
   sudo php artisan key:generate


#Configuration of mysql database
   sudo mysql start

  sudo mysql -u root<<EOF
#Functions to execute a MYSQL query
      execute_query() {
          local query=$1
          local database=$2

          ALTER USER 'root'@'localhost'
          IDENTIFIED WITH mysql_native_password BY 'DB_PASSWORD';
          FLUSH PRIVILEGES;
          mysql -u "$DB_USERNAME" -p "$DB_PASSWORD" "$database" -e "$query"
}

#Function to create a database
           create_database(){
           local database=$1
           execute_query "CREATE DATABASE $database"
}
EOF


#Change some environmental variables in the .env file
   sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=zenitugo/' /var/www/html/laravel/.env
   sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=sapphire/'  /var/www/html/laravel/.env
   sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=Debby/' /var/www/html/laravel/.env

#CACHE THE CONFIGURATIONS MADE
   php artisan config:cache

#MIGRATING THE SERVER
   php artisan migrate

#RESTART APACHE
   sudo systemctl restart apache2



