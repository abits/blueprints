# Class: webgrind
#
#
class webgrind {

  exec {'download_webgrind':
      cwd     => '/root',
      command => 'curl -O http://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
      creates => '/root/webgrind-release-1.0.zip',
      path    => '/usr/local/bin/:/bin/:/usr/bin/',  
      require => Package['curl'],
  }

  exec {'deflate_webgrind':
      cwd     => '/root',
      command => 'unzip /root/webgrind-release-1.0.zip',
      creates => '/root/webgrind',
      path    => '/usr/local/bin/:/bin/:/usr/bin/',  
      require => Exec['download_webgrind'],  
  }

  exec {'install_webgrind':
      cwd     => '/root',
      command => 'mv /root/webgrind /srv/www/webgrind',
      creates => '/srv/www/webgrind',
      path    => '/usr/local/bin/:/bin/:/usr/bin/',  
      require => Exec['deflate_webgrind'],  
  }

  file {'/srv/www/webgrind':
    ensure  => 'directory',
    owner   => 'vagrant',
    group   => 'vagrant',
  }

  file { '/etc/apache2/sites-enabled/40-www.webgrind.vbox.local.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    source  => 'puppet:///modules/webgrind/webgrind.vhost',
    notify  => Service['httpd'],
  }

}
