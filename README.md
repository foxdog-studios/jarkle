jarkle
======

Webaudio musical instrument

Controlled by a touch device! Watch as what you touch is played back on your
desktop.


setup
-----

For Arch linux

    $ ./scripts/setup/arch.sh

Everyone else needs to make sure they install meteorite

    $ sudo npm install -g meteorite

run
---

If you have all the prerequisites setup

    $ ./scripts/mrt.sh

or
    $ cd ./jarkle
    $ mrt


midimule
--------

This program will call a method on jarkle that will make stuff appear, it is
triggered by midi events.

    $ ./scripts/midimule.sh

