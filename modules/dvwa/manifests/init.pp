class dvwa {
    package {[
            'wget',
            'zip',
            'unzip',
        ]:
        ensure => present,
    }

    file { "/opt/downloads":
        ensure => "directory",
    }

    # Download the Damn Vulnerable Web App
    $dvwa_download = ''

}
