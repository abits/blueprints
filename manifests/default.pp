file { "/srv/www/drupal":
    ensure => "directory",
    owner  => "root",
    group  => "www-data",
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

package { [php5-mysql, php5-gd, php5-intl, php-pear, php5-xdebug, sudo]:
  ensure  => present,
  require => Class['apache::mod::php'],
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

file { "/etc/php5/conf.d/xxx-custom.ini":
  ensure => present,
  owner => root,
  group => root,
  mode => 644,
  source => ["/vagrant/files/php.ini"],
  notify => Service["httpd"],
  require => Class['apache::mod::php']
}
