# Class: framework
# Configure a basic framework setup
#
class frameworks( $framework, $dbms, $webserver ) {

    $php_frameworks    = [ 'drupal', 'symfony', 'typo3', 'wordpress' ]
    $python_frameworks = [ 'django', 'flask' ]

    file { '/srv/www/':
       ensure => 'link',
       target => '/vagrant/www',
       force => 'true',
    }

    file { '/vagrant/fabfile.pyc':
       ensure => 'absent',
    }


    if $framework == 'drupal' or $framework == 'symfony' {
        class { 'php_base': }
        class { 'webgrind': }
    }
    elsif $framework == 'django' {
        class { 'python_base': }      
    }
    else {
        fail("Unsupported framework $framework.  Check your settings in default.pp  => ")
    }


    class { $framework: }
    info("Getting ready for $framework.")

    if $dbms == 'mysql' {
      class { "db_$dbms": 
        db_name => $framework,
      }
    }
    else {
        fail("Unsupported dbms $dbms.  Check your settings in default.pp  => ")      
    }


    if $webserver == 'apache' {
        class { 'web_apache': 
          framework => $framework,
        }
    }
    else {
        fail("Unsupported webserver $webserver.  Check your settings in default.pp  => ")      
    }

}
