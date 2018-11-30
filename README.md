# NYU Libraries Privileges Guide

[![CircleCI](https://circleci.com/gh/NYULibraries/privileges.svg?style=svg)](https://circleci.com/gh/NYULibraries/privileges)
[![Maintainability](https://api.codeclimate.com/v1/badges/f3b156e217627398846e/maintainability)](https://codeclimate.com/github/NYULibraries/privileges/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/privileges/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/privileges?branch=master)

The NYU Libraries Privileges Guide offers a Web interface for finding patron permissions for a given sublibrary/patron status combination. While it is optimized for NYU's permission system it can be distributed to any system using Aleph or can act independently as a privileges management system. It is a Ruby on Rails application with a Solr indexed backend (using Sunspot for integration with ActiveRecord and Websolr cloud solution as the index).

## Getting Started

```
docker-compose build
docker-compose up dev
```

### Run tests

```
# To run rspec/cucumber suite
docker-compose run test
```

### Run locally without Docker

See the [dependencies](wiki/Dependencies) section for things to setup before you can get the application running.

### Starting up a development Solr instance

```
bundle exec sunspot-solr start -p 8984
```

## API

The Privileges Guide offers a standard Ruby on Rails RESTful JSON search and view API.

__Example of patron permission API__

Gets the permissions associated with a certain patron status.

    /patrons/71.json
    /patrons/71-nyu-alumni.json

See the [wiki page for more info about the API](https://github.com/NYULibraries/privileges/wiki/API).

## [Frontend](https://privileges.library.nyu.edu)
