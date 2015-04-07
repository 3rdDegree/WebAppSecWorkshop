# Give DVWA users a shell,
# and a copy of the app

define dvwa::user {
    require dvwa

    user { $name:
        ensure     => present,
        managehome => true,
        groups     => "www-data",
        password   => "webappsec",
        shell      => "/bin/bash",
    }

    exec {"$name-unzip-dvwa":
        command => "unzip -d /home/${name}/ ${dvwa::download_dir}/${dvwa::dvwa_zip}",
        path    => '/usr/bin',
        creates => "/home/${name}/${dvwa::dvwa_dir}",
        require => User[$name],
    }

    file {"$name-dvwa-files":
        path    => "/home/${name}/${dvwa::dvwa_dir}",
        recurse => true,
        owner   => $name,
        group   => 'www-data',
        require => Exec["$name-unzip-dvwa"],
    }

    $dvwa_config = "/home/${name}/${dvwa::dvwa_dir}/config/config.inc.php"

    # Set DVWA database name
    exec {"sed -i\'\' \'s/dvwa/${name}_db/\' $dvwa_config":
        path    => '/bin',
        onlyif  => "grep dvwa $dvwa_config",
        #notify  => Service['apache2'],
        require => File["/home/${name}/${dvwa::dvwa_dir}"],
    }

    # Set DVWA database user
    exec {"sed -i\'\' \'s/root/${name}/\' $dvwa_config":
        path    => '/bin',
        onlyif  => "grep root $dvwa_config",
        notify  => Service['apache2'],
        require => Exec["$name-unzip-dvwa"],
    }

    # Set DVWA database password
    exec {"sed -i\'\' \'s/p@ssw0rd/webappsec/\' $dvwa_config":
        path    => '/bin',
        onlyif  => "grep p@ssw0rd $dvwa_config",
        notify  => Service['apache2'],
        require => Exec["$name-unzip-dvwa"],
    }
}
