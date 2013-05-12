class frameworks::drupal {

    file { '/etc/apache2/sites-enabled/10-www.drupal.vbox.local.conf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/frameworks/drupal.vhost',
        notify  => Service['httpd'],
    }

    file { '/vagrant/fabfile.py':
       ensure  => 'present',
       replace => "no",
       source  => 'puppet:///modules/frameworks/drupal.fabfile',
       owner   => 'vagrant',
       group   => 'users',
    }
    
}