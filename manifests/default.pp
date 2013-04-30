file { '/srv/www/drupal':
    ensure => 'directory',
    owner  => 'root',
    group  => 'www-data',
    mode   => 755,
}

class {'apache': }
class {'apache::mod::php': }
apache::vhost { 'www.d8.local':
    require         => File['/srv/www/drupal'],
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/srv/www/drupal',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['drupal8.local',],
}
apache::mod { 'rewrite': }

package { [php5-mysql, 
           php5-gd, 
           php5-intl, 
           php-pear, 
           php5-xdebug, 
           php5-cli,
           sudo, 
           phpmyadmin,
           curl,
           libsqlite3-dev,
           git]:
  ensure  => present,
  require => [ Exec['apt_update'], 
               Class['apache::mod::php'] ],
  notify  => Service['httpd'],
}

class { 'mysql': }
class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
}
mysql::db { 'drupal':
  user     => 'drupal',
  password => 'drupal',
  host     => 'localhost',
  grant    => ['all'],
}

file { '/etc/php5/conf.d/xxx-custom.ini':
  ensure => present,
  owner => root,
  group => root,
  mode => 644,
  source => ['/vagrant/files/php.ini'],
  notify => Service['httpd'],
  require => Class['apache::mod::php']
}

exec { 'apt_update':
  command => '/usr/bin/apt-get update'
}

exec { 'download_composer':
  command => '/usr/bin/curl -s http://getcomposer.org/installer | php',
  cwd => '/tmp',
  require => Package['curl', 'php5-cli'],
  creates => '/tmp/composer.phar',
}
file { '/usr/local/bin':
  ensure => directory,
}
file { '/usr/local/bin/composer':
  ensure => present,
  source => '/tmp/composer.phar',
  require => [ Exec['download_composer'], File['/usr/local/bin'],],
  group => 'root',
  mode => '0755',
}
exec { 'update_composer':
  command => '/usr/local/bin/composer self-update',
  require => File['/usr/local/bin/composer'],
}

file { 'phpmyadmin_config':
  path => '/etc/phpmyadmin/config.inc.php',
  source => '/vagrant/files/config.inc.php',
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0444',
  require => Package[phpmyadmin],
}

exec { "pear auto_discover" :
  command => "/usr/bin/pear config-set auto_discover 1",
  require => [Package['php-pear']]
}
exec { "pear update-channels" :
  command => "/usr/bin/pear update-channels",
  require => [Package['php-pear'], Exec['pear auto_discover']]
}
exec {"pear install phpunit":
  command => "/usr/bin/pear install --alldeps -s pear.phpunit.de/PHPUnit",
  creates => '/usr/bin/phpunit',
  require => Exec['pear update-channels']
}
exec {"pear install drush":
  command => '/usr/bin/pear install --alldeps -s pear.drush.org/drush',
  creates => '/usr/bin/drush',
  require => Exec['pear update-channels']
}
exec {"pear install Console_Table":
  command => "/usr/bin/pear install --alldeps -s --force Console_Table",
  require => Exec['pear update-channels']
}

package { 'mailcatcher':
    ensure   => 'installed',
    provider => 'gem',
    require => Package['libsqlite3-dev']
}
exec {'run_mailcatcher':
    command => '/usr/local/bin/mailcatcher --http-ip 0.0.0.0',
    require => Package['mailcatcher']

}service { "exim4":
  ensure => "stopped",
}
