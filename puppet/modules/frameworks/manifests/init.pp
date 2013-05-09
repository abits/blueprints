# Class: drupal
# Configure a basic drupal setup
#
class frameworks( $type) {

    if $type == 'drupal' {
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

      mysql::db { 'drupal':
          user     => 'drupal',
          password => 'drupal',
          host     => 'localhost',
          grant    => ['all'],
      }
    }

    # exec {'download_drupal':
    #   cwd     => '/root',
    #   command => 'curl -O http://ftp.drupal.org/files/projects/drupal-8.x-dev.tar.gz',
    #   path    => '/usr/local/bin/:/bin/:/usr/bin/',
    #   creates => '/root/drupal-8.x-dev.tar.gz'
    # }

    # exec {'deflate_drupal':
    #   cwd     => '/root',
    #   command => 'tar xvf drupal-8.x-dev.tar.gz',
    #   path    => '/usr/local/bin/:/bin/:/usr/bin/',
    #   creates => '/root/drupal-8.x-dev',
    #   require => Exec['download_drupal'],
    # }

    # exec {'install_drupal':
    #   command  => 'mv /root/drupal-8.x-dev/* /srv/www/drupal',
    #   path     => '/usr/local/bin/:/bin/:/usr/bin/',
    #   require => [ File['/srv/www/drupal'], Exec['deflate_drupal'] ],
    # }



}
