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
