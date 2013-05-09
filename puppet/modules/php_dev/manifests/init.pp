# Class: php_dev
# Install php and php dev tools.

class php_dev {

    package { 
      [php5,
       php-apc,
       php5-mysql, 
       php5-gd, 
       php5-intl, 
       php-pear, 
       php5-xdebug, 
       php5-mcrypt,
       php5-cli,
       php5-curl,
       php5-dev,
       php5-imagick,
       php5-xsl, 
       graphviz, ]:
      notify  => Service['httpd'],
    }

    file { '/etc/php5/conf.d/xxx-custom.ini':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 644,
        source  => 'puppet:///modules/php_dev/php.ini',
        notify  => Service['httpd'],
        require => Package['php5'],
    }

    # on a dev system we run apache as vagrant
    file { '/var/lib/php/session' :
        owner  => 'root',
        group  => 'vagrant',
        mode   => 0770,
        require => Package['php5'],
    }

    exec { 'download_composer':
        command => 'curl -s http://getcomposer.org/installer | php',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        cwd     => '/tmp',
        creates => '/usr/bin/composer',
        require => Package['curl', 'php5-cli'],
    }

    exec { 'install_composer': 
        command => 'mv composer.phar /usr/bin/composer',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        cwd     => '/tmp',
        creates => '/usr/bin/composer',
        require => Exec['download_composer'],
    }

    file { '/usr/bin/composer':
        ensure  => 'present',
        require => Exec['install_composer'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    exec { 'update_composer':
        command => 'composer self-update',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        onlyif  => 'test -f /usr/bin/composer',
    }

    exec { 'pear auto_discover':
        command => 'pear config-set auto_discover 1',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        require => Package['php-pear'],
#        onlyif  => '/usr/bin/pear config-get auto_discover',
    }

    exec { 'pear update-channels':
        command => 'pear update-channels',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',        
        require => Exec['pear auto_discover'],
    }

    exec {'pear install phpunit':
        command => 'pear install --alldeps -s pear.phpunit.de/PHPUnit',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/bin/phpunit',
        require => Exec['pear update-channels'],
    }

    exec {'pear install drush':
        command => 'pear install --alldeps -s pear.drush.org/drush-6.0.0',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/bin/drush',
        require => Exec['pear update-channels'],
    }

    exec {'pear install Console_Table':
        command => 'pear install --alldeps -s --force Console_Table',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/share/php/Console/Table.php',
        require => Exec['pear update-channels'],
    }

    exec {'pear install PhpDocumentor':
        command => 'pear install --alldeps -s --force pear.phpdoc.org/PhpDocumentor-alpha',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/bin/phpdoc',
        require => Exec['pear update-channels'],
    }

    exec {'pear install PHP_CodeSniffer':
        command => 'pear install --alldeps -s --force PHP_CodeSniffer',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/bin/phpcs',
        require => Exec['pear update-channels'],
    }

    exec {'pear install PHP_PMD':
        command => 'pear install --alldeps -s --force pear.phpmd.org/PHP_PMD',
        path    => '/usr/local/bin/:/bin/:/usr/bin/',
        creates => '/usr/bin/phpmd',
        require => Exec['pear update-channels'],
    }

}
