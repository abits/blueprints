class django {

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

}