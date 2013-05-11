class drupal {

    file { '/srv/www/drupal':
         ensure => 'link',
         target => '/vagrant/www',
    }

    file { '/srv/www/django':
         ensure => 'absent',
         target => '/vagrant/www',
    }

    file { '/srv/www/symfony':
         ensure => 'absent',
         target => '/vagrant/www',
    }

    file { '/etc/apache2/sites-enabled/10-www.drupal.vbox.local.conf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/frameworks/drupal8.vhost',
        notify  => Service['httpd'],
    }
    
}