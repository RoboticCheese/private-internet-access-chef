# Encoding: UTF-8

name 'private-internet-access'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'apache2'
description 'Installs/configures the Private Internet Access VPN app'
long_description 'Installs/configures the Private Internet Access VPN app'
version '1.0.1'

source_url 'https://github.com/roboticcheese/private-internet-access-chef'
issues_url 'https://github.com/roboticcheese/private-internet-access-chef/' \
           'issues'

depends 'dmg', '~> 2.2'
depends 'windows', '~> 1.36'

supports 'mac_os_x'
supports 'windows'
