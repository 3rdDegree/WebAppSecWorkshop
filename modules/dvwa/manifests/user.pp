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
}
