class dvwa {
    package {[
            'wget',
            'zip',
            'unzip',
        ]:
        ensure => present,
    }

    $download_dir = "/opt/downloads"
    file { $download_dir:
        ensure => "directory",
    }

    # File/directory names
    $dvwa_ver = '1.0.8'
    $dvwa_zip = "v${dvwa_ver}.zip"
    $dvwa_dir = "DVWA-${dvwa_ver}"
    $dvwa_path = "${download_dir}/${dvwa_dir}"
    $dvwa_url = "https://github.com/RandomStorm/DVWA/archive/${dvwa_zip}"

    # Download the Damn Vulnerable Web App
    exec {'wget-dvwa':
        command => "wget ${dvwa_url} --directory-prefix=${download_dir}",
        path    => '/usr/bin', 
        creates => "${download_dir}/${dvwa_zip}",
        require => File[$download_dir],
    }
}
