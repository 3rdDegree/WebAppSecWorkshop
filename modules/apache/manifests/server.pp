class apache::server {

    $web_pkgs = ["apache2", "php5", "libapache2-mod-php5"]

    package { $web_pkgs:
        ensure => installed,
    }

    service { "apache2":
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package[$web_pkgs],
    }
}
