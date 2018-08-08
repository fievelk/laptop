Laptop
======

### ToDo:

- Test

Laptop (forked by fievelk) is a script to set up a Linux laptop for Rails development.

Requirements
------------

### Linux

We support:

* [14.04: Trusty Tahr](https://wiki.ubuntu.com/TrustyTahr/ReleaseNotes),
* [12.04 LTS: Precise Pangolin](https://wiki.ubuntu.com/PrecisePangolin/ReleaseNotes),
* Debian stable (currently [wheezy](http://www.debian.org/releases/stable/)).
* Debian testing (currently [jessie](http://www.debian.org/releases/testing/)).

Install
-------

### Linux

Read, then run the script:

    bash <(wget -qO- https://raw.githubusercontent.com/fievelk/laptop/ppp/linux/linux) 2>&1 | tee ~/laptop.log

Debugging
---------

Your last Laptop run will be saved to `~/laptop.log`. Read through it to see if
you can debug the issue yourself. If not, copy the lines where the script
failed into a [new GitHub
Issue](https://github.com/thoughtbot/laptop/issues/new) for us. Or, attach the
whole log file as an attachment.

What it sets up
---------------

* [Exuberant Ctags] for indexing files for vim tab completion
* [gh] for interacting with the GitHub API
* [Postgres] for storing relational data
* [Tmux] for saving project state and switching between projects
* [Watch] for periodically executing a program and displaying the output
* [Zsh] as your shell
* [Antigen] to manage ZSH plugins

[gh]: https://github.com/jingweno/gh
[Postgres]: http://www.postgresql.org/
[Tmux]: http://tmux.sourceforge.net/
[Watch]: http://linux.die.net/man/1/watch
[Zsh]: http://www.zsh.org/
[Antigen]: https://github.com/zsh-users/antigen/

It should take less than 15 minutes to install (depends on your machine).

Laptop can be run multiple times on the same machine safely. It will upgrade
already installed packages.

Make your own customizations
----------------------------

Put your customizations in `~/.laptop.local`. For example, your
`~/.laptop.local` might look like this:

    #!/bin/sh

    brew tap caskroom/cask
    brew install brew-cask

    brew cask install dropbox
    brew cask install google-chrome
    brew cask install rdio

You should write your customizations such that they can be run safely more than
once. See the `linux` scripts for examples.

Credits
-------

![thoughtbot](http://thoughtbot.com/assets/tm/logo.png)

Laptop is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community).
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

Thank you, [contributors](https://github.com/thoughtbot/laptop/graphs/contributors)!

Contributing
------------

Please see [CONTRIBUTING.md](https://github.com/thoughtbot/laptop/blob/master/CONTRIBUTING.md).

License
-------

Laptop is © 2011-2014 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the LICENSE file.
