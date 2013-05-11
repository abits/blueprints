# Class: dev_tools
# stand-alone tools for devs

class dev_tools {

    package { [ git,
                sudo,
                subversion,
                emacs23-nox,
                emacs-goodies-el,
                magit,
                php-elisp,
                python-mode,
                yaml-mode,
                yasnippet,   
                vim,
                htop,
                curl,
                links,
                lynx,
                swaks,
                telnet,
                ncftp,
                screen,
                p7zip-full,
                unzip,
                imagemagick,
                diffutils,
                colordiff,
                autoconf,
                automake,
                make,
                aspell,
                aspell-de,
                netcat,
                tcpdump,
                ssldump,
                ipgrab,
                ngrep,
                mailutils,
                rsync,
                gnupg2,
                sysstat,
                strace, ]:
        ensure  => latest,
    }

    file { '/etc/nanorc':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/dev_tools/nanorc',
    }

    file { '/home/vagrant/.emacs':
        ensure  => 'present',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
        source  => 'puppet:///modules/dev_tools/dot.emacs',
    }

    file { '/root/.emacs':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/dev_tools/dot.emacs',
    }

    file { '/home/vagrant/.emacs-custom.el':
        ensure  => 'present',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
    }

    file { '/root/.emacs-custom.el':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
    }

    file { '/home/vagrant/.emacs.d':
        ensure  => 'directory',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
    }

    file { '/home/vagrant/.emacs.d/lisp':
        ensure  => 'directory',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
        require => File['/home/vagrant/.emacs.d'],
    }

    file { '/root/.emacs.d':
        ensure  => 'directory',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
    }

    file { '/root/.emacs.d/lisp':
        ensure  => 'directory',
        owner   => 'vagrant',
        group   => 'vagrant',
        mode    => '644',
        require => File['/root/.emacs.d'],
    }

}