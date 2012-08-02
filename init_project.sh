#!/bin/bash
################################################
# put this file in to your web root directory  #
# !!! IMPORTANT:                               #
# !!! EDIT THIS SETTINGS BEFORE RUN SCRIPT !!! #
################################################
PATH_TO_WEB_DIR="/home/vasilij/web"
################################################

echo '################################################'
echo '# put this file in to your web root directory  #'
echo '# !!! IMPORTANT:                               #'
echo '# !!! EDIT THIS SETTINGS BEFORE RUN SCRIPT !!! #'
echo '################################################'
echo 'PATH_TO_WEB_DIR="'$PATH_TO_WEB_DIR'"'
echo '################################################'


echo "\n\nEnter git remote, or leave blank: "
read gitClone
if [ "$gitClone" = "" ]; then
  echo "\n\nCreate empty git repository? (y/n)"
  read gitCreate
fi
echo "\n\nEnter SITE folder: "
read site
echo "\n\nEnter URL: "
read url

if [ "$site" = "" ]; then
  echo "\n\nError: SITE must be specified, try again..."
  exit
elif [ "$url" = "" ]; then
  echo "\n\nError: URL must be specified, try again..."
  exit
fi

# cloning repository if specified
if [ $gitClone ]; then
  command git clone $gitClone $site
fi

# creating document root folder
mkdir -p $site/web

# creating symfony folder if specified
echo "\n\nCreate Symfony2 folders and apply permissions? (y/n)"
read s2f
if [ "$s2f" = "y" ]; then
  echo "#!/bin/bash" >> $site/permissions.sh
  echo "mkdir -p app/cache app/logs web/media web/uploads" >> $site/permissions.sh
  echo "chmod 777 app/cache app/logs web/media web/uploads" >> $site/permissions.sh
  echo "sudo setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs web/media web/uploads" >> $site/permissions.sh
  echo "sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs web/media web/uploads" >> $site/permissions.sh
  cd $site/
  sh permissions.sh
  cd ../
  echo 'Symfony2 folders created'
fi

# creating empty git repository if specified
if [ $gitCreate ]; then
  # creating .gitignore file
  echo "# Bootstrap" 		>> $site/.gitignore
  echo "app/bootstrap*" 	>> $site/.gitignore
  echo "" 			>> $site/.gitignore
  echo "# Symfony directories" 	>> $site/.gitignore
  echo "vendor/*"		>> $site/.gitignore
  echo "*/logs/*" 		>> $site/.gitignore
  echo "*/cache/*" 		>> $site/.gitignore
  echo "web/uploads/*" 		>> $site/.gitignore
  echo "web/bundles/*" 		>> $site/.gitignore
  echo "" 			>> $site/.gitignore
  echo "# Configuration files" 	>> $site/.gitignore
  echo "app/config/parameters.yml" >> $site/.gitignore
  echo "" 			>> $site/.gitignore
  echo "# IDE" 			>> $site/.gitignore
  echo ".idea/*" 		>> $site/.gitignore
  echo "nbproject/*" 		>> $site/.gitignore
  echo "" 			>> $site/.gitignore
  echo "# other" 		>> $site/.gitignore
  echo ".directory" 		>> $site/.gitignore
  echo "*.*~" 			>> $site/.gitignore

  # creating readme file
  echo "$site" 			>> $site/README.md
# init repository
  cd $site/
  command git init
  command git add .
  command git commit -m "init repository"
  cd ../
fi


# creating symfony folder if specified
echo "\n\nApply apache configuratiin? (y/n)"
read a2c
if [ "$a2c" = "y" ]; then
  # add apache configuration1
  sudo sh -c 'echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "      ServerName '$url'" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "      DocumentRoot '$PATH_TO_WEB_DIR'/'$site'/web" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "      <Directory '$PATH_TO_WEB_DIR'/'$site'/web>" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "              AllowOverride All" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "      </Directory>" >> /etc/apache2/sites-available/'$site
  sudo sh -c 'echo "</VirtualHost>" >> /etc/apache2/sites-available/'$site
  # enabling site
  sudo a2ensite $site
  # restarting apache
  sudo service apache2 restart
  # adding site to hosts
  sudo sh -c ' echo "127.0.0.1       '$url'" >> /etc/hosts'
fi

echo "\n\n All should work now :)"