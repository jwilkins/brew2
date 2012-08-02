1.0 TODO
========
Stuff that must be done before even considering 2.0
* when upgrading and removing deps
   * executables of all formula that depend on it for their install_name deps
     to ensure the new version has that dylib still, otherwise abort
* allow upgrade keg-only formula, but don't delete old keg, ensure user is aware of
  the reasons the old ones are still around
* If destination of Cellar->PREFIX symlink exists and is a directory, abort!
* Fix autotools
  * including fullpaths to the tools so we call the right ones etc.
  * https://github.com/mxcl/homebrew/issues/10824

2.0
===
* Make brew-bot set new master after running tests for core changes,
  collaborators can set future_master or whatever
* Build proper tests for everything as-we-go
* versions have to be Ruby numerical
* deps can depend on >= versions
* conflicts can be defined (formula, including variants, including taps)
* brew doctor will scan for all base deps on the system too so that we can be used
  on Linux
* cache git checkouts as eg. foo.git. Should be possible to pull multiple
  histories into same .git folder and then checkout as appropriate
* make brew upgrade show which formula are new versions and which are just updates
  to some other part of the formula
* proper handling for etc files (make a new git repo and version control them)
* Don't store metadata eg. LinkedKegs/Taps in a repo directory
* put core homebrew library code in lib?
* Handle frameworks that are compiled properly?
* Tap specific cellars? Would allow you to install tapped dupes and keep them keg-only.
    /etc/cellar/mxcl-master/
    /etc/cellar/homebrew-dupes/
* Metadata in cellar:
    /etc/cellar/mxcl-master/foo/HOLD  #empty file
    /etc/cellar/homebrew-dupes/foo/ACTIVE -> 1.10  #symlink
* Support formula renames well and without regression
