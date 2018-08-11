Follower Maze
====================

**Doesn't include the followermaze files as I didn't program them**

To run the program it is best to open 2 shells.
First start the servers via:

    ruby bin/run.rb
    # or just
    bin/run.rb

And in the other shell start the follower maze program to start sending and receiving data:

    ./followermaze.sh

Then watch it fly :) Currently on my desktop (i7 870, 4 cores) it takes 370-395 seconds to finish. Ruby versions (as well as JRuby startup options) seem not to have a real impact on this as of now.

## Setup

Tested on Linux Mint 17 64-bit edition (based on Ubuntu 14.04):


        soundcloud_challenge $ uname -a
        Linux desktop 3.13.0-24-generic #47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
        soundcloud_challenge $ java -version
        java version "1.7.0_65"
        OpenJDK Runtime Environment (IcedTea 2.5.3) (7u71-2.5.3-0ubuntu0.14.04.1)
        OpenJDK 64-Bit Server VM (build 24.65-b04, mixed mode)

## Ruby compatibility

Works and is tested on JRuby 1.7.16.1 and CRuby/MRI 2.1.5 (and 2.1.4).

It does not work with rubinius/rbx as tested on 2.2.10 because it seemed not to send out answers to the clients, for instance: "Mon Nov 24 10:48:50 CET 2014 [ERROR] Client 26 expected line 48548|S|377, but got ."

Also some specs fail on rubinius, while they are just fine for CRuby/JRuby.

