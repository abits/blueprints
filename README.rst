==============
vagrant-drupal
==============

Basic stack for php/drupal development.

Setup
-----

.. code:: bash

  git clone 'repo'
  git submodule init
  git submodule update
  vagrant up

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