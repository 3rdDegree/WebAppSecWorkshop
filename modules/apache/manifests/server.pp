class apache::server {
    package { "apache2":
        ensure => installed,
    }

    service { "apache2":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package["apache2"],
    }
}
