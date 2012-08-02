init-project
============

This is a simple bash script automates the creation of a new symfony2 project.

What it actually do?
* Cloning remote or creatie empty git repository.
* Creates symfoy2 cache, logs and web directories.
* Applyes facl and chmod to those directories.
* Creates permissions.sh to apply facl and chmod later.
* Creates apache2 vhost for your project.
* Adds your project url to hosts file.

How to use it?
* Put init_project.sh in to your web (htdocs) directory.
* Edit init_project.sh and change PATH_TO_WEB_DIR variable
* Run init_project ( sh init_project.sh )
