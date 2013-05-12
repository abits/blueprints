blueprints
==========

Blueprints for web development stacks.

How it works
------------

Puppet prepares Debian Wheezy server for web applications based on some
frameworks.  Vagrant gives you access to the servers in a virtual machine.
And, finally, fabric helps you bootstrapping the frameworks in your workspace.
Cool.


How to use
----------

Clone this repo in a directory of your choosing.  Initialize and clone
dependencies.

.. code::

  $ git clone 'repo'
  $ git submodule init
  $ git submodule update

Decide which framework you want to use - it's Drupal, Symfony, and Django for
now (more to come) - and modify ``puppet/modules/manifest/default.pp``.  Find
the declaration of class ``frameworks`` and switch the parameter ``framework``
to one of ``drupal``, ``symfony``, or ``django``.  

.. code:: ruby

  class { 'frameworks': 
      name => 'symfony',
  }

Then run 

.. code::

  $ vagrant up

This should set up a virtual machine for the desired framework, e.g. a basic
LAMP stack with default virtual host and databases plus a set of dev tools.


Finde die Deklaration für die
Klasse ``framework`` und  setze den Parameter ``name`` auf ``symfony``:

.. code:: ruby

  class { 'frameworks': 
      name => 'symfony',
  }

Per default Vagrant will try to mount your project folder in the virtual
machine via NFS.  This requires that you've got a NFS server running on the
host machine.  I've only tested this under Arch Linux where I only needed to 
install the package ``nfs-utils`` and start the servers with:

.. code::

  # systemctl restart rpc-idmapd
  # systemctl restart rpc-mountd

Make sure your host network adapter is properly configured for host only
communication (again, under Arch Linux):

.. code::

  # ip link set vboxnet0 up
  # ip addr add 33.33.33.1/24 dev vboxnet0

For more information on nfs, see for 
`Fedora <https://fedoraproject.org/wiki/Archive:Docs/Drafts/Administration Guide/Servers/NetworkFileSystem>`_
and
`Ubuntu <https://help.ubuntu.com/community/SettingUpNFSHowTo>`_.

Puppet will install a ``fabfile.py`` in your project folder with some tasks
ready to bootstrap your framework.  It should also contain task which do the
host configuration above.

If you don't want nfs, just comment out the following line in the ``Vagrantfile``:

.. code:: ruby

  config.vm.synced_folder(".", "/vagrant", :nfs => true, :nfs_version => 4)

You will then need to sync your folders manually over SSH.

The virtual machine has the IP ``33.33.33.10``.  Add comfort by defining
some addresses in your host's ``/etc/hosts``:

.. code::

  33.33.33.10   www.vbox.local
  33.33.33.10   phpmyadmin.vbox.local
  33.33.33.10   webgrind.vbox.local

Webgrind is an xdebug profiler frontend which is only added for PHP projects.

Databases
---------

Puppet configures default databases, which can be used by your projects:

.. code::

  Db name: <framework>
  Db username: <framework>
  Db password: <framework>

E.g. for Drupal you'll find a mysql database of the name ``drupal`` accessible
for a user ``drupal`` authenticated with password ``drupal``.
You can manage mysql databases with `PhpMyAdmin <phpmyadmin.vbox.local>`_ with:

.. code::

  User: root
  Password: password


Boostrapping
------------

While Vagrant manages the VM and Puppet sets up tools, web and database
servers as required, it's fabric which bootstraps the actual source code of
the framework.  If you want to do this by hand, you can stop here and are
ready to go. 

All source code goes in a directory ``www/`` under your project root.  If
fabric finds such a directory while bootstrapping, it will back it up.

See what your shining new ``fabfile.py`` has to offer by running ``fab -l`` in
the directory where ``fabfile.py`` is; this file is only created if it doesn't
exist.  So you can later savely modify and extend it as part of your project.

Install the framework of your choice with:

.. code::
  
  $ fab bootstrap

This downloads and installs the necessary code into ``www/``.  You can specify
certain versions of Drupal or Symfony by adding a parameter, like so:

.. code::

  $ fab bootstrap:version=7.22
  $ fab bootstrap:version=2.2.0

You will hit the wall, if fabric can't find that version.


What now?
---------

Symfony does not allow remote acces to the dev dispatcher by default.  Modify 
``www/web/app_dev.php`` to change this.  

Install Drupal online by visiting <http://www.vbox.local/install.php> or 
<33.33.33.10/install.php>.
