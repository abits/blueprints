# Class: framework
# Configure a basic framework setup
#
class frameworks( $name, $dbms, $webserver ) {

    file { '/srv/www/':
       ensure => 'link',
       target => '/vagrant/www',
       force => 'true',
    }

    if $name == 'drupal' or $name == 'symfony' {
        class { 'php_base': }
        class { 'webgrind': }
    }

    if $name == 'django' or $name == 'flask' {
        class { 'python_base': }      
    }

    if $name == 'drupal' {
        class { 'drupal': }
        info("Getting ready for Drupal.")
    }

    if $name == 'symfony' {
        class { 'symfony': }
        info("Getting ready for Symfony.")
    }

    if $name == 'django' {
        class { 'django': }
        info("Getting ready for Django.")
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
