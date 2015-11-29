# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'private-internet-access'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs/configures the Private Internet Access VPN app'
long_description 'Installs/configures the Private Internet Access VPN app'
version          '1.0.0'

depends          'dmg', '~> 2.2'
depends          'windows', '~> 1.36'

supports         'mac_os_x'
supports         'windows'
# rubocop:enable SingleSpaceBeforeFirstArg
