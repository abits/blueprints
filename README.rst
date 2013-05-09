==============
vagrant-webdev
==============

Basic stack for web development.

Setup
-----

.. code:: bash

  git clone 'repo'
  git submodule init
  git submodule update
  sudo ./ip-up.sh
  sudo ./start-nfs.sh
  vagrant up

Die beiden Shell-Skripte konfigurieren den Netzwerkadapter und den nfs-Server beim Host.  

vhosts
------

.. code:: bash

  33.33.33.10   www.dev.vbox.local
  33.33.33.10   dev.vbox.local
  33.33.33.10   phpmyadmin.vbox.local
  33.33.33.10   webgrind.vbox.local

phpmyadmin
----------

.. code:: bash

  User: root
  Password: password

Drupal install
--------------

.. code:: bash

  Db name: drupal
  Db username: drupal
  Db password: drupal
