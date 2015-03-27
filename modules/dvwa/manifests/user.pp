# Give DVWA users a shell,
# and a copy of the app

define dvwa::user {
    user { $name:
        ensure     => present,
        managehome => true,
        groups     => "www-data",
        password   => "webappsec",
    }
}
