class frameworks::django {

    file { '/srv/www/django':
       ensure => 'link',
       target => '/vagrant/www',
    }

    file { '/srv/www/symfony':
       ensure => 'absent',
       target => '/vagrant/www',
    }

    file { '/srv/www/drupal':
       ensure => 'absent',
       target => '/vagrant/www',
    }

    file { '/vagrant/fabfile.py':
       ensure  => 'present',
       replace => "no",
       source  => 'puppet:///modules/frameworks/django.fabfile',
       owner   => 'vagrant',
       group   => 'users',
    }

}