# Class: zsh
# Install and configure zsh shell for vagrant and root
class zsh {

    package { 'zsh':
        ensure => present
    }

    user { 'vagrant':
        ensure  => present,
        shell   => '/usr/bin/zsh',
        require => Package['zsh'],
    }

    file { 'zsh_rc_vagrant':
        path    => '/home/vagrant/.zshrc',
        source  => 'puppet:///modules/zsh/zshrc',
        ensure  => file,
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '0444',
        require => Package['zsh'],
    }

    user { 'root':
        ensure  => present,
        shell   => '/usr/bin/zsh',
        require => Package['zsh'],
    }

    file { 'zsh_rc':
        path    => '/root/.zshrc',
        source  => 'puppet:///modules/zsh/zshrc',
        ensure  => file,
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '0444',
        require => Package['zsh'],
    }

}