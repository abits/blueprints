# Class: mailcatcher
# Install and configure mailcatcher

class mailcatcher {
    
    package { 'libsqlite3-dev':
      ensure  => 'installed',
    }

    package { 'mailcatcher':
        ensure   => 'installed',
        provider => 'gem',
        require  => Package['libsqlite3-dev']
    }

    exec {'run_mailcatcher':
        command => 'mailcatcher --ip 0.0.0.0',
        require => Package['mailcatcher'],
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        unless  => "/bin/netstat -lanp tcp | /bin/grep -c 0.0.0.0:1080",
        returns => ['0', '255'],
    }
}