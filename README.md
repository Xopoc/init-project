init-project
============

This is a simple bash script automates the creation of a new symfony project 2.

What it actually do?
1* Cloning remote or creatie empty git repository.
2* Creates symfoy2 cache, logs and web directories.
3* Applyes facl and chmod to those directories.
4* Creates permissions.sh to apply facl and chmod later.
5* Creates apache2 vhost for your project.
6* Adds your project url to hosts file.