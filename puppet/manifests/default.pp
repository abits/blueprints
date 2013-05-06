# setting up a basic LAMP stack for Drupal development
# (c) Chris Martel <chris@codeways.org>

# update package database
exec { 'apt_update':
    command => 'apt-get update',
    path    => '/usr/local/bin/:/bin/:/usr/bin/',  
}


# set up web and database servers
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

class { 'mysql': }
class { 'mysql::server':
    config_hash => { 
        root_password => 'password',
        bind_address => '0.0.0.0'
    }
}


# set up php
class { 'apache::mod::php': }
class { 'php_dev': }


# set up tools
class { 'mailcatcher': }
class { 'dev_tools': }
class { 'zsh': }
class { 'phpmyadmin': }
class { 'python_base': }
class { 'webgrind': }
apache::vhost { 'www.webgrind.vbox.local':
    require         => Class['webgrind'],
    priority        => '40',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/srv/www/webgrind',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['webgrind.vbox.local',],
}


# set up vhost and db access for Drupal

# drupal 
exec {'download_drupal':
  cwd     => '/tmp',
  command => 'wget http://ftp.drupal.org/files/projects/drupal-8.x-dev.tar.gz',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/srv/www/drupal/index.php',
}

exec {'deflate_drupal':
  cwd     => '/tmp',
  command => 'tar xvf drupal-8.x-dev.tar.gz',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/srv/www/drupal/index.php',
  require => Exec['download_drupal'],
}

exec {'install_drupal':
  command => 'mv /tmp/drupal-8.x-dev /srv/www/drupal',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/srv/www/drupal/index.php',
  require => Exec['deflate_drupal'],
}

file {'/srv/www/drupal':
  owner => 'vagrant',
  group => 'vagrant',
  mode  => '644',
}

apache::vhost { 'www.dev.vbox.local':
    require         => Exec['install_drupal'],
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    override        => 'All',
    docroot         => '/srv/www/drupal',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['dev.vbox.local',],
}
mysql::db { 'drupal':
    user     => 'drupal',
    password => 'drupal',
    host     => 'localhost',
    grant    => ['all'],
}