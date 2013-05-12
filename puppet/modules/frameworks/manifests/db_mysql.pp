class db_mysql($db_name) {
  class { 'mysql': }
  class { 'mysql::server':
      config_hash => { 
          root_password => 'password',
          bind_address => '0.0.0.0'
      }
  }
  mysql::db { $name:
    user     => $db_name,
    password => $db_name,
    host     => 'localhost',
    grant    => ['all'],
  }
  class { 'phpmyadmin': }
}