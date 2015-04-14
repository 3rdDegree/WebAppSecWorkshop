# Config targets Ubuntu 12.04 LTS (32 bit)
#
# Install VirtualBox, Vagrant, then run
# "vagrant up" to provision the lab envirnonment

$users = [
    'dan',
    'steveo',
    'johnny',
#    '',
#    '',
#    '',
]

node 'webappsec' {
    include apt
    include apache::server
    include mysql::server

    include dvwa

    dvwa::user { $users: }
    dvwa::db   { $users: }
    dvwa::web  { 'dvwa-site': users => $users }
}

# Make Package resources dependant on apt-get update
Class['apt'] -> Package <| |>
