define dvwa::db($user = $name) {
    require mysql::server

    $schema = "$user_db"
    $password = 'webappsec'

    exec { "$name-schema":
        unless  => "mysql -uroot $schema",
        command => "mysqladmin -uroot create $schema",
        path    => "/usr/bin/",
    }

    exec { "$name-user":
        unless  => "mysql -u$user -p$password $schema",
        command => "mysql -uroot -e \"GRANT ALL PRIVILEGES ON \
                    $schema.* TO '$user'@'%' \
                    IDENTIFIED BY '$password';\"",
        path    => "/usr/bin/",
        require => Exec["$name-schema"],
    }
}

