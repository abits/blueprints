class frameworks::django {

    file { '/etc/apache2/sites-enabled/10-django.conf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/frameworks/django-apache-wsgi.vhost',
        notify  => Service['httpd'],
    }

    file { '/vagrant/fabfile.py':
       ensure  => 'present',
       replace => "no",
       source  => 'puppet:///modules/frameworks/django.fabfile',
       owner   => 'vagrant',
       group   => 'users',
    }

}