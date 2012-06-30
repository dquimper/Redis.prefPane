## Redis.prefPane

A Mac OS X system preference pane which aids in starting and stopping the Redis database server.

Features include:

Start and Stop of the database server
Enabling and Disabling the auto-start option when your computer boots up.

## Screenshot

![prefPane screenshot](https://github.com/dquimper/Redis.prefPane/raw/master/Redis.prefPane.png)

## Installation

1. Install Redis using [HomeBrew](http://mxcl.github.com/homebrew/)
	1. brew install redis
1. Copy `homebrew.mxcl.redis.plist` to your `~/Library/LaunchAgents`
	1. `mkdir -p ~/Library/LaunchAgents`
	1. `cp /usr/local/Cellar/redis/2.4.13/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/`
1. Edit your `/usr/local/etc/redis.conf`
	1. find the line with `daemonize no`
	1. change it to `daemonize yes`
1. Download the prefPane or clone and compile it yourself.
	1. Download: [Redis.prefPane](https://github.com/dquimper/Redis.prefPane/raw/master/Redis.prefPane.zip)
	1. Git clone: `git clone git://github.com/dquimper/Redis.prefPane.git`

## License

All the work [Salvatore Sanfilippo](http://twitter.com/antirez) and [Pieter Noordhuis](http://twitter.com/pnoordhuis) are doing in order to develop [Redis](http://redis.io) is sponsored by [VMware](http://vmware.com/).

The Redis logo was designed by [Carlos Prioglio](http://www.carlosprioglio.com/). See more [credits](http://redis.io/topics/sponsors).

The source code for the pref pane is Open Source under MIT License. See the LICENSE file for full details of the MIT License.

## Why

This is my first MacOSX application and my first experience with Objective-C.

This project was created to mimic the mySQL Preference pane that you get from downloading the mySQL tarball. The code is shamelessly copied and adapted from the [pgpane](https://github.com/jwang/pgpane) project by John Wang (a Postgres prefPane).

It was created to help non-technical people in getting their Ruby on Rails system set up with Redis, and are not too familiar with the Terminal app and unix commands.

## Similar projects

* The PostgreSQL prefPane ([github](https://github.com/jwang/pgpane)) by John Wang
* Preference Pane for MacFUSE ([github](https://github.com/liquid/MacFUSE-PrefPane))
* PassengerPrefPane compiled for OSX Lion Intel 64-bits ([github](https://github.com/SoftwhisperSL/PassengerPrefPane-OSX10.7))
* mongoDB pref pane for MacOS X ([github](https://github.com/ivanvc/mongodb-prefpane))