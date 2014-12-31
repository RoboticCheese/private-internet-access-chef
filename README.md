Private Internet Access Cookbook
================================
[![Cookbook Version](http://img.shields.io/cookbook/v/private-internet-access.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/RoboticCheese/private-internet-access-chef.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/RoboticCheese/private-internet-access-chef.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/RoboticCheese/private-internet-access-chef.svg)][coveralls]

[cookbook]: https://supermarket.getchef.com/cookbooks/private-internet-access
[travis]: http://travis-ci.org/RoboticCheese/private-internet-access-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/private-internet-access-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/private-internet-access-chef

A Chef cookbook for installing the Private Internet Access application.

Requirements
============

This cookbook requires an OS X or Windows node, as those are the only OSes
PIA distributes a client app for.

It consumes the [dmg](https://supermarket.chef.io/cookbooks/dmg) and
[windows](https://supermarket.chef.io/cookbooks/windows) cookbooks to support
OS X and Windows installs.

Usage
=====

Resources can be called directly or the main recipe that uses those resources
can be added to your run\_list.

Recipes
=======

***default***

Calls the `private_internet_access` resource to do a package install.

Attributes
==========

***default***

A custom package URL can be provided.

    default['private_internet_access']['package_url'] = nil

Resources
=========

***private_internet_access***

Wraps the fetching and installation of a remote package into one main resource.

Syntax:

    private_internet_access 'pia' do
        package_url 'https://somewhere.org/pia.dmg'
        action :install
    end

Actions:

| Action     | Description                           |
|------------|---------------------------------------|
| `:install` | Default; installs the PIA application |

Attributes:

| Attribute    | Default    | Description                                   |
|--------------|------------|-----------------------------------------------|
| package\_url | `nil`      | Optionally download package from a custom URL |
| action       | `:install` | The action to perform                         |

Providers
=========

***Chef::Provider::PrivateInternetAccess***

A generic provider for all non-platform-specific functionality.

***Chef::Provider::PrivateInternetAccess::MacOSX***

Provides the Mac OS X platform functionality.

***Chef::Provider::PrivateInternetAccess::Windows***

Provides the Windows platform functionality.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2014 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.