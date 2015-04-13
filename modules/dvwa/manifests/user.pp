# Give DVWA users a shell,
# and a copy of the app

define dvwa::user {
    require dvwa

    user { $name:
        ensure     => present,
        managehome => true,
        groups     => "www-data",
        shell      => "/bin/bash",
    }

    $passwd = '\$1\$LVQeW\.dW\$21Bz7C6oDmVR93T24CFIK\/'  # webappsec

    # Set user password
    exec {"${name}-password":
        command => "sed -i\'\' \'s/${name}:!/${name}:${passwd}/\' /etc/shadow",
        path    => '/bin',
        require => User[$name],
    }


    # Fix VI arrow keys when in insert mode
    file {"/home/$name/.vimrc":
        ensure  => present,
        content => "set nocompatible",
        require => User[$name],
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

    # Make upload dir world writeable
    file {"$name-dvwa-upload":
        path    => "/home/${name}/${dvwa::dvwa_dir}/hackable/uploads/",
        recurse => true,
        mode    => 0777,
        require => Exec["$name-unzip-dvwa"],
    }

    $dvwa_config = "/home/${name}/${dvwa::dvwa_dir}/config/config.inc.php"

    $schema = "${name}_db"

    # Set DVWA database name
    exec {"${name}-config-dbname":
        command => "sed -i\'\' \'s/dvwa/${schema}/\' $dvwa_config",
        path    => '/bin',
        onlyif  => "grep dvwa $dvwa_config",
        #notify  => Service['apache2'],
        require => File["/home/${name}/${dvwa::dvwa_dir}"],
    }

    # Set DVWA database user
    exec {"${name}-config-dbuser":
        command => "sed -i\'\' \'s/root/${name}/\' $dvwa_config",
        path    => '/bin',
        onlyif  => "grep root $dvwa_config",
        notify  => Service['apache2'],
        require => Exec["$name-unzip-dvwa"],
    }

    # Set DVWA database password
    exec {"${name}-config-dbpass":
        command => "sed -i\'\' \'s/p@ssw0rd/webappsec/\' $dvwa_config",
        path    => '/bin',
        onlyif  => "grep p@ssw0rd $dvwa_config",
        notify  => Service['apache2'],
        require => Exec["$name-unzip-dvwa"],
    }

    # Set DVWA security level
    exec {"${name}-config-seclevel":
        command => "sed -i\'\' \'s/\"high\"/\"low\"/\' $dvwa_config",
        path    => '/bin',
        onlyif  => "grep \"high\" $dvwa_config",
        notify  => Service['apache2'],
        require => Exec["$name-unzip-dvwa"],
    }

    # Run the DVWA Database Setup script
    $setup_output = "/tmp/setup_${name}.txt"
    exec {"${name}-setup-dvwa-db":
        command => "wget http://localhost/${name}/setup.php -q --post-data=create_db=1 --output-document=${setup_output}",
        path    => '/usr/bin',
        creates => $setup_output,
        require => [Service['apache2'],
                    Service['mysql'],
                    File["/home/${name}/${dvwa::dvwa_dir}"],
                    Exec["${name}-config-dbname"],
                    Exec["${name}-config-dbuser"],
                    Exec["${name}-config-dbpass"]
        ]
    }

    # Add an account for this user in the DVWA database
    exec { "${name}-dvwa-login":
        command => "mysql -uroot -D ${schema} -e \"insert into users \
                        (first_name, last_name, user, password) \
                        values('${name}', '${name}', '${name}', '4d06a78774eebd9d28d3996cbf35e9c3');\"",
        path    => "/usr/bin/",
        require => Exec["${name}-setup-dvwa-db"],
    }

    # Fixup paths to avatars
    exec { "${name}-dvwa-avatar":
        command => "mysql -uroot -D ${schema} -e \"update users \
                        set avatar = REPLACE(avatar, 'dvwa/', '/${name}/') \
                        where avatar like 'dvwa/%';\"",
        path    => "/usr/bin/",
        require => Exec["${name}-dvwa-login"],
    }
}
