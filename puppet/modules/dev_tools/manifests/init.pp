# Class: dev_tools
# stand-alone tools for devs

class dev_tools {

    package { [ git,
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
                make, ]:
        ensure  => present,
    }

}