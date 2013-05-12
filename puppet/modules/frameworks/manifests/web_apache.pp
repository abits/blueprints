class web_apache( $framework ) {
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
      if $framework == 'drupal' or $framework == 'symfony' {
        class { 'apache::mod::php': }
      }
      elsif $framework == 'django' {
        apache::mod { 'wsgi': }
      }
}