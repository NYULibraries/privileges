# NYU Libraries Privileges Guide

[![Build Status](https://travis-ci.org/NYULibraries/privileges.png?branch=master)](https://travis-ci.org/NYULibraries/privileges)
[![Dependency Status](https://gemnasium.com/NYULibraries/privileges.png)](https://gemnasium.com/NYULibraries/privileges)
[![Code Climate](https://codeclimate.com/github/NYULibraries/privileges.png)](https://codeclimate.com/github/NYULibraries/privileges)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/privileges/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/privileges)

The NYU Libraries Privileges Guide offers a Web interface for finding patron permissions for a given sublibrary/patron status combination. While it is optimized for NYU's permission system it can be distributed to any system using Aleph or can act independently as a privileges management system. It is a Ruby on Rails (>= 3.2) application with a Solr indexed backend (using Sunspot for integration with ActiveRecord and Websolr cloud solution as the index).

## Dependencies

The application implements Solr/Sunspot for indexing, delayed_job for delayed indexing and Memcached with Dalli for robust caching. While the first two are required in the Gemfile and will be automatically installed with bundler, memcached needs to be installed manually on the application server. See http://memcached.org/. 

If you wish to use Rails built-in caching server instead of memcached remove the following line in the relevant environment file (e.g. development.rb, production.rb):

    config.cache_store = :dalli_store, 'localhost:11211'

To ensure that memcached is running on your server run the command

    ~$ /etc/init.d/memcached status
  
And then start it up if it is not running

    ~$ /etc/init.d/memcached start

Its presence in init.d should indicate that it is set to run on startup.

### Loading the data from Aleph and indexing in Websolr
The NYU permission matrix is stored and managed in the Exlibris inventory system Aleph. The privileges guide harvests the data from Aleph into ActiveRecord and then allows for additional permission entries to be added directly to the application without any repercussions in Aleph. 

The Aleph tables with the permissions currently have to be mounted on the local file system and then an initializer in privileges guide uses the [exlibris-aleph](https://github.com/scotdalton/exlibris-aleph) gem to pull the relevant ADM information out. The initializer looks like this:

    Exlibris::Aleph::TabHelper.init("/mnt/aleph_tab", ["NYU50", "NYU51"])

#### Indexing and delay
Because all the permission data is indexed in a cloud implementation of Solr (i.e. WebSolr) there is a delay between when changes are saved by admins in the database and when the changes are reflected to frontend users. The actual indexing is also queued as a background job with [delayed_job](https://github.com/collectiveidea/delayed_job) so admins can continue their changes while the application does the heavy lifting. The delay might be several minutes, but the indexing ultimately allows for faster retrieval of the data.

### [Frontend](https://privileges.library.nyu.edu)

### APIs
The Privileges Guide offers JSON search and view APIs.

__Example of patron permission API__

Gets the permissions associated with a certain patron status.

    /patrons/71.json
    /patrons/71-nyu-alumni.json

Both give the following JSON output with basic information:

    {
        "patron_status_permissions": null,
        "sublibrary": null,
        "patron_status": {
            "code": "nyu_ag_noaleph_alumni",
            "created_at": "2009-09-07T01:16:35Z",
            "description": "NYU Alumni with a valid NYU Alumni membership card are entitled to 3 free visits to Bobst Library. For expanded access privileges, alumni may join the <a href=\"http://library.nyu.edu/alumni/friends.html\">Friends of Bobst Program</a>. ",
            "from_aleph": false,
            "id": 71,
            "id_type": "Pass issued by Bobst Library Privileges Office",
            "keywords": "alumni, nyu graduate, alum, former student, graduated",
            "original_text": null,
            "under_header": "NYU",
            "updated_at": "2012-10-08T21:43:07Z",
            "visible": true,
            "web_text": "NYU Alumni"
        }
    }
    
Adding a sublibrary will give you the permissions:

    /patrons/71.json?sublibrary_code=BOBST

With output:

    {
        "patron_status_permissions": [
            {
                "created_at": "2009-09-07T01:20:22Z",
                "from_aleph": false,
                "id": 15494,
                "patron_status_code": "nyu_ag_noaleph_alumni",
                "permission_value_id": 46,
                "permission_value_web_text": "Full access to Bobst Stacks. Access to Bobst LL1 and LL2 limited to 7 a.m. to 1 a.m.",
                "permission_web_text": "Library Access",
                "sublibrary_code": "BOBST",
                "updated_at": "2009-09-07T01:20:22Z",
                "visible": true
            },
            {
                "created_at": "2009-09-18T16:35:30Z",
                "from_aleph": false,
                "id": 16258,
                "patron_status_code": "nyu_ag_noaleph_alumni",
                "permission_value_id": 92,
                "permission_value_web_text": "need text.",
                "permission_web_text": "E-access",
                "sublibrary_code": "BOBST",
                "updated_at": "2009-09-18T16:35:30Z",
                "visible": true
            },
            {
                "created_at": "2009-09-07T01:20:32Z",
                "from_aleph": false,
                "id": 15495,
                "patron_status_code": "nyu_ag_noaleph_alumni",
                "permission_value_id": 53,
                "permission_value_web_text": "No borrowing privileges",
                "permission_web_text": "Borrowing privileges",
                "sublibrary_code": "BOBST",
                "updated_at": "2009-09-07T01:20:32Z",
                "visible": true
            },
            {
                "created_at": "2009-09-18T16:35:39Z",
                "from_aleph": false,
                "id": 16259,
                "patron_status_code": "nyu_ag_noaleph_alumni",
                "permission_value_id": 61,
                "permission_value_web_text": "Not eligible for interlibrary loan services. Request interlibrary loans at public library or affliliated institution.",
                "permission_web_text": "Interlibrary loans",
                "sublibrary_code": "BOBST",
                "updated_at": "2009-09-18T16:35:39Z",
                "visible": true
            }
        ],
        "sublibrary": {
            "code": "BOBST",
            "created_at": "2009-08-14T18:11:58Z",
            "from_aleph": true,
            "id": 14,
            "original_text": "NYU Bobst",
            "under_header": "NYU Bobst Library",
            "updated_at": "2012-10-22T17:55:08Z",
            "visible": true,
            "web_text": "<a href=\"http://library.nyu.edu/\">NYU Bobst</a>"
        },
        "patron_status": {
            "code": "nyu_ag_noaleph_alumni",
            "created_at": "2009-09-07T01:16:35Z",
            "description": "NYU Alumni with a valid NYU Alumni membership card are entitled to 3 free visits to Bobst Library. For expanded access privileges, alumni may join the <a href=\"http://library.nyu.edu/alumni/friends.html\">Friends of Bobst Program</a>. ",
            "from_aleph": false,
            "id": 71,
            "id_type": "Pass issued by Bobst Library Privileges Office",
            "keywords": "alumni, nyu graduate, alum, former student, graduated",
            "original_text": null,
            "under_header": "NYU",
            "updated_at": "2012-10-08T21:43:07Z",
            "visible": true,
            "web_text": "NYU Alumni"
        }
    }
    
Which can be parsed for web text anywhere the API is implemented.

__Example of patron statuses API__

The following GET will retrieve all patron statuses listed for printing:

    /patrons.json
    
Adding a `sublibrary_code=` param to the querystring will return a JSON representation of all patron statuses with access to the specified sublibrary.

## Scheduled jobs

There is a daily Jenkins cron job which loads in new values from Aleph and deletes those deleted from Aleph. These values are then reindexed into Solr. 

The Development index is kicked off at **2am** each morning and the Production reindex triggers when the Development one has been successfully completed.

The build status for this job:

[![Build Status](http://jenkins.library.nyu.edu/buildStatus/icon?job=Privileges Guide Production Solr Reindex Cron)](http://jenkins.library.nyu.edu/view/Crons/job/Privileges%20Guide%20Production%20Solr%20Reindex%20Cron/)
