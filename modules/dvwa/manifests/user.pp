# Give DVWA users a shell,
# and a copy of the app

define dvwa::user {
    require dvwa

    user { $name:
        ensure     => present,
        managehome => true,
        groups     => "www-data",
        password   => "webappsec",
    }

    file {"/home/${name}/${dvwa::dvwa_dir}":
        ensure  => directory,
        source  => $dvwa::dvwa_path,
        recurse => true,
        owner   => $name,
        group   => 'www-data',
        require => User[$name],
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
        #notify  => Service['apache2'],
        require => File["/home/${name}/${dvwa::dvwa_dir}"],
    }

    # Set DVWA database password
    exec {"sed -i\'\' \'s/p@ssw0rd/webappsec/\' $dvwa_config":
        path    => '/bin',
        onlyif  => "grep p@ssw0rd $dvwa_config",
        #notify  => Service['apache2'],
        require => File["/home/${name}/${dvwa::dvwa_dir}"],
    }
}
