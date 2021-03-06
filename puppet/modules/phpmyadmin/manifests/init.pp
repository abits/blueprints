# Class: phpmyadmin
# Install and configure phpymadmin


class phpmyadmin {

    package { 'phpmyadmin':
        ensure  => 'installed',
    }

    file { 'phpmyadmin_config':
        ensure  => 'present',
        path    => '/etc/phpmyadmin/config.inc.php',
        source  => 'puppet:///modules/phpmyadmin/config.inc.php',
        require => Package['phpmyadmin'],
        notify  => Service['apache2'],    
        owner  => 'root',
        group  => 'root',
        mode   => '0444',    
    }

    file { 'phpmyadmin_vhost':
        ensure  => 'present',
        path    => '/etc/apache2/sites-enabled/20-phpmyadmin.conf',
        source  => 'puppet:///modules/phpmyadmin/phpmyadmin.vhost',
        require => Package['phpmyadmin'],
        notify  => Service['apache2'],  
        owner  => 'root',
        group  => 'root',
        mode   => '0444',   
    }

    file { '/usr/share/phpmyadmin':
        ensure  => 'directory',
        require => Package['phpmyadmin'],
        owner  => 'vagrant',
        group  => 'vagrant',
    }
}