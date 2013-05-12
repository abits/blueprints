class frameworks::symfony {

    file { '/etc/apache2/sites-enabled/10-www.symfony.vbox.local.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      source  => 'puppet:///modules/frameworks/symfony2.vhost',
      notify  => Service['httpd'],
    }

    file { '/vagrant/fabfile.py':
       ensure  => 'present',
       replace => "no",
       source  => 'puppet:///modules/frameworks/symfony.fabfile',
       owner   => 'vagrant',
       group   => 'users',
    } 
}