# Class: python_base
# Install general purpose python packages

class python_base {

    package { [ python-pip,
                python-virtualenv,
                python-dev,
                python-docutils,
                python-sphinx, ]:
        ensure => 'latest',
    }

    file { '/usr/local/bin':
        ensure => 'directory',
    }

    exec {'install_fabric':
        cwd     => '/root',
        command => '/usr/bin/pip install fabric',
        creates => '/usr/local/bin/fab',
        require => Package['python-pip'],  
    }

}