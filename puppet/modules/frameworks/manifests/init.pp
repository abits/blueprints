# Class: framework
# Configure a basic framework setup
#
class frameworks( $name ) {

    if $name == 'drupal' {
      file { '/srv/www/drupal':
         ensure => 'link',
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

    if $name == 'symfony' {
        file { '/srv/www/symfony':
           ensure => 'link',
           target => '/vagrant/www',
        }

        file { '/etc/apache2/sites-enabled/10-www.symfony.vbox.local.conf':
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '644',
          source  => 'puppet:///modules/frameworks/symfony2.vhost',
          notify  => Service['httpd'],
        }
    }

    mysql::db { $name:
      user     => $name,
      password => $name,
      host     => 'localhost',
      grant    => ['all'],
    }

}
