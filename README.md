Private Internet Access Cookbook
================================
[![Cookbook Version](https://img.shields.io/cookbook/v/private-internet-access.svg)][cookbook]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/private-internet-access-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/private-internet-access-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/private-internet-access-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/private-internet-access-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/private-internet-access
[travis]: https://travis-ci.org/RoboticCheese/private-internet-access-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/private-internet-access-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/private-internet-access-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/private-internet-access-chef

A Chef cookbook for installing the Private Internet Access VPN application.

Requirements
============

This cookbook requires an OS X or Windows node, as those are the only OSes
PIA distributes a client app for.

It consumes the [dmg](https://supermarket.chef.io/cookbooks/dmg) and
[windows](https://supermarket.chef.io/cookbooks/windows) cookbooks to support
OS X and Windows installs.

As of v1.0.0, it uses custom resources that require Chef 12.5 or greater.

Usage
=====

Resources can be called directly or the main recipe that uses those resources
can be added to your run\_list.

Recipes
=======

***default***

Calls the `private_internet_access` resource to do an attribute-driven install.

Attributes
==========

***default***

A custom package URL/path can be provided.

    default['private_internet_access']['app']['source'] = nil

Resources
=========

***private_internet_access***

Wraps the other PIA resources under one parent resource.

Syntax:

    private_internet_access 'default' do
        source 'https://somewhere.org/pia.dmg'
        action :create
    end

Actions:

| Action    | Description           |
|-----------|-----------------------|
| `:create` | Default; installs PIA |
| `:remove` | Uninstalls PIA        |

Attributes:

| Attribute | Default   | Description                                   |
|-----------|-----------|-----------------------------------------------|
| source    | `nil`     | Optionally download the app from a custom URL |
| action    | `:create` | The action to perform                         |

***private_internet_access_app***

Controls installation of the PIA client app.

Syntax:

    private_internet_access_app 'default' do
        source 'https://somewhere.org/pia.dmg'
        action :install
    end

Actions:

| Action     | Description                          |
|------------|--------------------------------------|
| `:install` | Default; installs the PIA client app |
| `:remove`  | Uninstalls the PIA client app        |

Attributes:

| Attribute | Default    | Description                                   |
|-----------|------------|-----------------------------------------------|
| source    | `nil`      | Optionally download the app from a custom URL |
| action    | `:install` | The action to perform                         |

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

Copyright 2014-2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
