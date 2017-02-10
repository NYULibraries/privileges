# Change Log

## 2017-02-10

- Setup rake task to clean out old users: `rake privileges:cleanup:users`
- Move aleph_load rake task into appropriate namespace: `rake privileges:load_aleph`

## 2016-09-30

- Change `web_text` field from `:string` to `:text` on `PermissionValues` table to allow for longer descriptions
- Only run travis on current application version and latest version of Ruby

## 2013-10-25

### Functional Changes
- __Shibboleth Integration__  
  We've integrated the [PDS Shibboleth integration](https://github.com/NYULibraries/pds-custom/wiki/NYU-Shibboleth-Integration)
  into this release.

### Technical Changes
- :gem: __Updates__: Most gems are up to date. We're not on Rails 4, so that's the exception, but Rails 3.2.15 security vulnerability closed.

- __Update authpds-nyu__: Use the Shibboleth version of the
  [NYU PDS authentication gem](https://github.com/NYULibraries/authpds-nyu/tree/v1.1.2).

- __Update exlibris-nyu__ Use the newly refactored version of the [Exlibris NYU gem](https://github.com/NYULibraries/exlibris-nyu).

- __Use nyulibraries_deploy__ Refactored to use the [NYU Libraries Deploy gem](https://github.com/NYULibraries/nyulibraries_deploy) for capistrano recipe simplification and the ability to send diff emails.

- __Refactor__
  A bit of a code refactor to clean up and optimize in a Rails fashion, e.g. use of respond_with, upped code coverage, etc.
