class mysql::server {
    package { "mysql-server":
        ensure => installed,
    }

    service { "mysql":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package["mysql-server"],
    }

    exec { "remove-anonymous-user":
        command => "mysql -uroot -e \"DELETE FROM mysql.user \
                    WHERE user=''; \
                    FLUSH PRIVILEGES\"",
        onlyif  => "mysql -u' '",
        path    => "/usr/bin",
        require => Service["mysql"],
    }
}
