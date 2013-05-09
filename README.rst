blueprints
==========

Blueprints for web development stacks.

Setup
-----

.. code:: bash

  $ git clone 'repo'
  $ git submodule init
  $ git submodule update
  $ fab start_nfs
  $ vagrant up
  $ fab ip_up

Die beiden `Fabric <http://docs.fabfile.org/>`_ tasks ``fab <TASK>``
konfigurieren den Netzwerkadapter und den nfs-Server beim Host unter Arch
Linux.  Damit *shared folder* mit nfs funktioniert, muss auf dem Host ein nfs-
server laufen. Unter Arch (und wahrscheinlich Fedora) reicht es dazu, das
Paket ``nfs- utils`` zu installieren und die Daemons über das Skript zu
starten. Weitere Infos für
`Fedora <https://fedoraproject.org/wiki/Archive:Docs/Drafts/Administration Guide/Servers/NetworkFileSystem>`_ 
und für  
`Ubuntu <https://help.ubuntu.com/community/SettingUpNFSHowTo>`_. 
Im Host interessiert nur der Server-Part; Vagrant übernimmt die Konfiguration
beim Hochfahren und benutzt  dafür ``sudo``; außer dem Starten der nötigen
Daemons (rpc und idmapd) sollte im Host nichts weiter zu tun sein.

vhosts
------

.. code:: bash

  33.33.33.10   www.drupal.vbox.local  drupal.vbox.local
  33.33.33.10   www.symfony.vbox.local symfony.vbox.local
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

Puppet konfiguriert den Server - aber nicht den Quellcode.  Um Drupal 8 in das
Verzeichnis ``www/`` zu installieren, kommt `Fabric <http://docs.fabfile.org/>`_
zum Einsatz:

.. code:: bash
  
  $ fab bootstrap_drupal

*Achtung*: Dateien und Verzeichnisse in www/ wird ggf. überschrieben. Fabric
ist auf den meisten Distributionen als Paket verfügbar.  Eine Liste von
ausführbaren Tasks erhält man mit ``fab -l``.  Fabric muss immer in dem
Verzeichnis aufgerufen werden, in dem sich die Datei ``fabfile.py`` befindet.
Die Drupal Site ist erreichbar unter http://www.drupal.vbox.local/install.php, 
sofern die Datei ``/etc/hosts`` entsprechend konfiguriert ist.


Symfony install
---------------

*Aber ich möchte Symfony!* Kein Problem.  Für Puppet ist der Schalter dafür in
der Datei ``puppet/manifests/default.pp``.  Finde die Deklaration für die
Klasse ``framework`` und  setze den Parameter ``name`` auf ``symfony``:

.. code:: ruby

  class { 'frameworks': 
      name => 'symfony',
  }

Das ``fabfile.py`` hält auch für Symfony einen Task vor: 

.. code:: bash

  $ fab bootstrap_symfony

Dieser Task führt eine Symfony-Installation mit ``composer`` remote in der
Virtuellen Maschine durch.  Danach ist die Site ansprechbar unter
http://www.symfony.vbox.local/app_dev.php (sofern die ``/etc/hosts`` Datei
entsprechend angepasst wurde).  *Achtung*: Symfony verbietet per default den
Zugriff auf den Dev-Controller von remote hosts.  Deshalb ist noch die Datei
``www/web/app_dev.php`` entsprechend anzupassen, um den Zugriff vom Host zu
erlauben.  
