# encoding: utf-8
# frozen_string_literal: true

name 'private-internet-access'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'apache2'
description 'Installs/configures the Private Internet Access VPN app'
long_description 'Installs/configures the Private Internet Access VPN app'
version '1.0.1'
chef_version '>= 12.6'

source_url 'https://github.com/roboticcheese/private-internet-access-chef'
issues_url 'https://github.com/roboticcheese/private-internet-access-chef/' \
           'issues'

depends 'dmg', '~> 3.1'

supports 'mac_os_x'
supports 'windows'
