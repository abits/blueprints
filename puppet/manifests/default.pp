# Setting up software stacks for web development.
# (c) 2013, Chris Martel <chris@codeways.org>

# update package database
exec { 'apt_update':
    command => 'apt-get update',
    path    => '/usr/local/bin/:/bin/:/usr/bin/',  
}

# set up a framework, use drupal or symfony as value for $type
class { 'frameworks': 
    name      => 'drupal',
    dbms      => 'mysql',
    webserver => 'apache',
}

# set up tools
class { 'mailcatcher': }
class { 'dev_tools': }
class { 'zsh': }

