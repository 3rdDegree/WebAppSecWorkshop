#puppet module install maestrodev-wget
#puppet module install camptocamp-archive
#puppet module install puppetlabs-java
#puppet module install puppetlabs-tomcat
#apt-get install zip unzip

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
    include dvwa
}
