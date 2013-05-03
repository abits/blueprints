# default attributes of file resource
File {
  ensure => 'present',
  owner  => 'root',
  group  => 'root',
  mode   => 644,
}

file { '/usr/local/bin':
  ensure => 'directory',
}

exec { 'apt_update':
  command => '/usr/bin/apt-get update'
}

# web server and virtual hosts
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
  owner => root,
  group => root,
  mode => 644,
  notify => Service['httpd'],
}
file { '/var/lock/apache2':
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'root',
    mode   => 755,
}

# mailcatcher
package { 'libsqlite3-dev':
  ensure => 'installed',
}
package { 'mailcatcher':
    ensure   => 'installed',
    provider => 'gem',
    require => Package['libsqlite3-dev']
}
exec {'run_mailcatcher':
    command => '/usr/local/bin/mailcatcher --ip 0.0.0.0',
    require => Package['mailcatcher'],
    creates => '/usr/local/bin/mailcatcher'
}

# webgrind
apache::vhost { 'www.webgrind.dev.local':
    require         => Exec['install_webgrind'],
    priority        => '20',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/srv/www/webgrind',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['webgrind.dev.local',],
}
exec {'download_webgrind':
  cwd     => '/root',
  command => 'curl -O http://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/root/webgrind-release-1.0.zip',
  require => Package['curl'],
}
exec {'deflate_webgrind':
  cwd     => '/root',
  command => 'unzip /root/webgrind-release-1.0.zip',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/root/webgrind',
  require => Exec['download_webgrind'],  
}
exec {'install_webgrind':
  cwd     => '/root',
  command => 'mv /root/webgrind /srv/www/webgrind',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/srv/www/webgrind',
  require => Exec['deflate_webgrind'],  
}

# zsh rules!
package { 'zsh':
  ensure => present
}
user { 'vagrant':
  ensure => present,
  shell  => '/usr/bin/zsh',
  require => Package['zsh']
}
file { 'zsh_rc_vagrant':
  path => '/home/vagrant/.zshrc',
  source => '/vagrant/puppet/files/zshrc',
  ensure => file,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0444',
  require => Package['zsh'],
}
user { 'root':
  ensure => present,
  shell  => '/usr/bin/zsh',
  require => Package['zsh']
}
file { 'zsh_rc':
  path => '/root/.zshrc',
  source => '/vagrant/puppet/files/zshrc',
  ensure => file,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0444',
  require => Package['zsh'],
}

# stand-alone tools for devs
package {
  [git,
   sudo,
   subversion,
   emacs23-nox,
   emacs-goodies-el,   
   vim,
   htop,
   curl,
   links,
   ncftp,
   screen,
   p7zip-full,
   imagemagick,
   diffutils,
   autoconf,
   automake,
   make]:
  ensure => present,
  require => [ Exec['apt_update'], ], 
}

# mysql and phpmyadmin
class { 'mysql': }
class { 'mysql::server':
  config_hash => { 
    root_password => 'password',
    bind_address => '0.0.0.0'
  }
}
mysql::db { 'drupal':
  user     => 'drupal',
  password => 'drupal',
  host     => 'localhost',
  grant    => ['all'],
}
package { 'phpmyadmin':
  ensure => installed,
}
apache::vhost { 'www.phpmyadmin.dev.local':
    require         => Package['phpmyadmin'],
    priority        => '30',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/usr/share/phpmyadmin',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['phpmyadmin.dev.local',],
}
file { 'phpmyadmin_config':
  path => '/etc/phpmyadmin/config.inc.php',
  source => '/vagrant/puppet/files/config.inc.php',
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0444',
  require => Package['phpmyadmin'],
}
file { 'phpmyadmin_alias':
  path => '/etc/apache2/sites-enabled/20-phpmyadmin.conf',
  source => '/etc/phpmyadmin/apache.conf',
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0444',
  require => Package['phpmyadmin'],
  notify => Service['apache2']
}

# php install and configuration
class {'apache::mod::php': }
package { 
  [php5-mysql, 
   php5-gd, 
   php5-intl, 
   php-pear, 
   php5-xdebug, 
   php5-mcrypt,
   php5-cli,
   php5-curl,
   php5-dev,
   php5-imagick]:
  notify  => Service['httpd'],
  require => [ Exec['apt_update'], 
             Class['apache::mod::php'] ],
 }
file { '/etc/php5/conf.d/xxx-custom.ini':
  ensure => present,
  owner => root,
  group => root,
  mode => 644,
  source => ['/vagrant/puppet/files/php.ini'],
  notify => Service['httpd'],
  require => Class['apache::mod::php'],
}
exec { 'download_composer':
  command => '/usr/bin/curl -s http://getcomposer.org/installer | php',
  cwd => '/tmp',
  require => Package['curl', 'php5-cli'],
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
exec { 'pear auto_discover' :
  command => '/usr/bin/pear config-set auto_discover 1',
  require => Package['php-pear']
}
exec { 'pear update-channels' :
  command => '/usr/bin/pear update-channels',
  require => Exec['pear auto_discover']
}
exec {'pear install phpunit':
  command => '/usr/bin/pear install --alldeps -s pear.phpunit.de/PHPUnit',
  creates => '/usr/bin/phpunit',
  require => Exec['pear update-channels']
}
exec {'pear install drush':
  command => '/usr/bin/pear install --alldeps -s pear.drush.org/drush-6.0.0',
  creates => '/usr/bin/drush',
  require => Exec['pear update-channels']
}
exec {'pear install Console_Table':
  command => '/usr/bin/pear install --alldeps -s --force Console_Table',
  creates => '/usr/share/php/Console/Table.php',
  require => Exec['pear update-channels']
}
exec {'pear install PhpDocumentor':
  command => '/usr/bin/pear install --alldeps -s --force PhpDocumentor',
  creates => '/usr/bin/phpdoc',
  require => Exec['pear update-channels']
}
exec {'pear install PHP_CodeSniffer':
  command => '/usr/bin/pear install --alldeps -s --force PHP_CodeSniffer',
  creates => '/usr/bin/phpcs',
  require => Exec['pear update-channels']
}
exec {'pear install PHP_PMD':
  command => '/usr/bin/pear install --alldeps -s --force pear.phpmd.org/PHP_PMD',
  creates => '/usr/bin/phpmd',
  require => Exec['pear update-channels']
}


# python
package { 
  [python-pip,
   python-virtualenv,
   python-dev]:
   ensure => installed,
}
exec {'install_fabric':
  cwd     => '/root',
  command => '/usr/bin/pip install fabric',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/usr/local/bin/fab',
  require => Package['python-pip'],  
}

# drupal 
file { '/srv/www/drupal':
    ensure => 'directory',
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 755,
}
apache::vhost { 'www.d8.dev.local':
    require         => File['/srv/www/drupal'],
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    override        => 'All',
    docroot         => '/srv/www/drupal',
    serveradmin     => 'admin@localhost',
    serveraliases   => ['d8.dev.local',],
}
