file { "/srv/www/drupal":
    ensure => "directory",
    owner  => "root",
    group  => "www-data",
    mode   => 755,
}

class {'apache': }
class {'apache::mod::php': }
apache::vhost { 'www.d8.local':
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/srv/www/drupal',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['drupal8.local',],
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