define dvwa::web($users) {

    # Disable default website
    exec { 'disable-default-site':
        command => '/usr/sbin/a2dissite default',
        onlyif  => "/usr/bin/test -f /etc/apache2/sites-enabled/000-default",
    }

    # Install the site config file
    $site_name = 'webappsec'
    $apache_site = "/etc/apache2/sites-available/${site_name}"

    file {'dvwa-site':
        content => template('dvwa/apache_webappsec.erb'),
        mode    => 0644,
        path    => $apache_site,
        require => Package['apache2'],
    }

    # Enable the DVWA site
    exec { "/usr/sbin/a2ensite ${site_name}":
        unless  => "/usr/bin/test -f /etc/apache2/sites-enabled/${site_name}",
        notify  => Service['apache2'],
        require => [ File['dvwa-site'], Exec['disable-default-site'] ],
    }

    # Change php.ini settings
    $php_ini = '/etc/php5/apache2/php.ini'
    exec {"sed -i\'\' \'s/allow_url_include = Off/allow_url_include = On/\' $php_ini":
        path    => '/bin',
        onlyif  => "grep \"allow_url_include = Off\" $php_ini",
        notify  => Service['apache2'],
        require => Package["php5"],
    }
}

