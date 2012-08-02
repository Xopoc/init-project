init-project
============

This is a simple bash script automates the creation of a new symfony project 2.

What it actually do?
* Cloning remote or creatie empty git repository.
* Creates symfoy2 cache, logs and web directories.
* Applyes facl and chmod to those directories.
* Creates permissions.sh to apply facl and chmod later.
* Creates apache2 vhost for your project.
* Adds your project url to hosts file.