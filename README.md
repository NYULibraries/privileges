# NYU Libraries Privileges Guide

[![Build Status](https://travis-ci.org/NYULibraries/privileges.png?branch=master)](https://travis-ci.org/NYULibraries/privileges)
[![Dependency Status](https://gemnasium.com/NYULibraries/privileges.png)](https://gemnasium.com/NYULibraries/privileges)
[![Code Climate](https://codeclimate.com/github/NYULibraries/privileges.png)](https://codeclimate.com/github/NYULibraries/privileges)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/privileges/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/privileges)

The NYU Libraries Privileges Guide offers a Web interface for finding patron permissions for a given sublibrary/patron status combination. While it is optimized for NYU's permission system it can be distributed to any system using Aleph or can act independently as a privileges management system. It is a Ruby on Rails application with a Solr indexed backend (using Sunspot for integration with ActiveRecord and Websolr cloud solution as the index).

## Getting Started

See the [dependencies](wiki/Dependencies) section for things to setup before you can get the application running.

### Starting up a development Solr instance

Use the foreman Procfile to manage startup tasks:

```
bundle exec foreman start
```

## API

The Privileges Guide offers a standard Ruby on Rails RESTful JSON search and view API.

__Example of patron permission API__

Gets the permissions associated with a certain patron status.

    /patrons/71.json
    /patrons/71-nyu-alumni.json

See the [wiki page for more info about the API](https://github.com/NYULibraries/privileges/wiki/API).

## [Frontend](https://privileges.library.nyu.edu)
