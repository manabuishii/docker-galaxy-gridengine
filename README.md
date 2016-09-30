[![Build Status](https://travis-ci.org/manabuishii/docker-galaxy-gridengine.svg?branch=master)](https://travis-ci.org/manabuishii/docker-galaxy-gridengine)

# docker-galaxy-gridengine
Docker Galaxy with Grid Engine

# About Test Plan

share data with ```-v``` .

* start SGE master
* start docker galaxy
* run job from bioblend
 * fetch content
 * some count tool ?
* check tool result via bioblend
* check SGE master history

or 

create new tool which shows just hostname.

or

using selenium, casperjs or some other browser test

# log file in SGE master

To check GridEngine error

```
/var/spool/gridengine/execd/sgemaster/messages
```
