# Class: framework
# Configure a basic framework setup
#
class frameworks( $name, $dbms, $webserver ) {

    @file { '/srv/www':
      ensure => 'directory',
      owner  => 'vagrant',
      group  => 'vagrant',
      mode   => '644',
    }

    realize File['/srv/www']

    if $name == 'drupal' or $name == 'symfony' {
      class { 'php_dev': }
    }

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

        info("Getting ready for Drupal 8.  If successful you may want to bootstrap using: fab bootstrap_drupal")

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

        info("Getting ready for Symfony 2.  If successful you may want to bootstrap using: fab bootstrap_symfony")
    }

    if $dbms == 'mysql' {

      class { 'mysql': }

      class { 'mysql::server':
          config_hash => { 
              root_password => 'password',
              bind_address => '0.0.0.0'
          }
      }

      mysql::db { $name:
        user     => $name,
        password => $name,
        host     => 'localhost',
        grant    => ['all'],
      }

      class { 'phpmyadmin': }

    }

    if $webserver == 'apache' {

      class {'apache': }
      apache::mod { 'alias': }
      apache::mod { 'autoindex': }
      apache::mod { 'cache': }
      apache::mod { 'deflate': }
      apache::mod { 'dir': }
      apache::mod { 'expires': }
      apache::mod { 'headers': }
      apache::mod { 'mime': }
      apache::mod { 'negotiation': }
      apache::mod { 'rewrite': }
      apache::mod { 'setenvif': }
      apache::mod { 'status': }

      file { '/etc/apache2/envvars':
          ensure => file,
          source => ['/vagrant/puppet/files/envvars',],
          owner  => root,
          group  => root,
          mode   => 644,
          notify => Service['httpd'],
      }

      file { '/var/lock/apache2':
          ensure => 'directory',
          owner  => 'vagrant',
          group  => 'vagrant',
          mode   => 755,
      }

      if $name == 'drupal' or $name == 'symfony' {
        class { 'apache::mod::php': }
      }

    }

}
