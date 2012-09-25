TweetLike
=========
About
-----
A full Mojolicious app built around Net::Twitter.

The idea around Tweetlike is to make sharing tweets in other social networks (like Facebook) an easier task.

Installation
------------

###Configuration

First things first, clone the repository. After that you must make your own twitter app and get your own secret/key tokens.

After that, make your own app.conf file using app.conf.example as a template.

###Initialization

Tweetlike needs a database to store users metadata. An sql schema is provided under the directory script/

SQlite3 is used as the DB backend for this project (It's easy to migrate to a bigger backend). To inialize the DB you must run:
```
sqlite3 users.db < script/db.sql
```

Running
-------

Just run morbo script/TweetLike and try for yourself

License
-------
GPL3

Copyright 2012 - Sergio Conde < skgsergio [at] gmail [dot] com >

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
