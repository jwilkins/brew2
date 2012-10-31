Homebrew 2 Design Bin
=====================
This is just some messing around in the aid of improving Homebrew for revision
two. Don't worry, we'll finish Homebrew 1.0 first.

Feel free to fork and suggest improvements.

Requirements
============
* A standards compliant c-compiler
* BSD or GNU curl, tar, unzip
* Ruby 1.8+
* The following base libraries:

libz
libxml2
libcrypto
libcurl
libiconv
libpng
libicucore
libm
libpam
libpcre
libq

Basically everything that MacOS comes with.

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
* optional deps: https://github.com/mxcl/homebrew/issues/13923
* Don't by default allow people to uninstall deps of other things (requires
  install_recipt)

2.0
===
* OS-agnostic
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
    /etc/cellar/homebrew-dupes/foo/CURRENT -> 1.10  #symlink
* Support formula renames well and without regression
* - is not valid in version strings
* Figure out allowed characters for github repos and usernames and ensure we
  support all that without messing about.
* upgrading HEAD formula
* operate on the active keg link as a default, stops weird behavior like `brew rm ack`
  uninstalling whatever keg is left in there. If it is not actively linked then this
  should be a cleanup operation, possibly
* Can do in ruby script: require `brew --require`
* Need to handle formula from a tap not loading because using features from
  newer brew-core code. Possibly just handle exception and prompt user to update
* copy the formula that was used for install into the keg, so eg. we can see
  which deps where used when installing.
* A great launchctl system
* A great .app system
* Allow formula to output strings. Eg:
     brew couchdb --plist-path
  NOTE only strings
* Formula.etc should not necessarily be PREFIX/etc but we should manage etc files
  and probably automatically diff for previous versions and inform the user about stuff
  or ideally put the diff in the git staging area or something
* If a formula has another formula eg. ruby and ruby19 then all formula names should
  be versioned
* Make it so dependencies or dependencies install by saying what they are deps off:
    installing foo dep of bar dep of goo
* Link Frameworks in
* Can adopt command format of other popular package managers, eg. apt. Maybe this would turn out stupid, but worth a play.

* Build into opt and then move old versions into an archive-pen. Switching is
  literally moving the directory and re-symlinking. Simplifies everything.

Brew2 Taps
==========
* taps end with .hbtap or .brewtap so they can easily by googled/github-searche
* capability for extensions to manage other things, eg. textmate bundles,
  quicklook plugins, cocoapods
* allow taps hooks so they can modify homebrew behavior, eg. have an uninstall
  hook
* allow dependencies to be virtual, they are eg lib/brew/deps/x11 this is a
  requirement
* for linux formula can have a component that detects them from the system
  this can also thus be used on mac to determine if pre-existing and installed
  libraries are new enough etc.
* Support for Aliases, requires the Formula style tap layout
* If the tap is a full URL first try to checkout a "homebrew" branch, encouraging
  people to put the formula in a detached-branch if they store formula in the repo
  that is also their source repo, this will keep the fetch size down (I think)
  and keep things neater in the checked-out tap.
  

NOTE in brew 2 currently HOMEBREW_REPOSITORY must equal HOMEBREW_PREFIX
I'm not sure if we should give a shit? It's not possible to have a regular
UNIX directory structure and have that feature. Regular UNIX dirs is desirable
IMO. But maybe not that worth it?

NOTE in brew 2 we lose /Library and spread everything around in a POSIX
fashion. This is kind of better, kind of worse. Overall *I* prefer it, but 
maybe it's not the right thing to do still.


ISSUES TO SOLVE
===============
Removed formula from a tap can then be overridden by new formula with the same
name. Must be be made impossible.

KEG ONLY SUCKS
==============
https://github.com/mxcl/homebrew/issues/13546#issuecomment-7537859

Having pango not upgrade to new cairo caused build issues