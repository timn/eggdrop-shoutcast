##############################################################################
#
# Eggdrop Script for ShoutCast stats
# Copyright (C) 2003-2004 by Tim Niemueller <tim@niemueller.de>
# http://www.niemueller.de/software/eggdrop/shout/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# Created  : May 2003
#
# $Id: shout.tcl,v 1.1 2004/01/26 00:38:46 tim Exp $
#
##############################################################################


###CONFIGSTART###

# URL of shoutcast info page
set url "http://streamserver:8000/"

# The full path to shout.pl
set shoutpath "/server/irc/eggdrop/scripts/eggshout/shout.pl"

#   path to your perl binary
set perlbin "/usr/bin/perl"

###CONFIGEND###


# some random monkey code by tim
####### DON'T CHANGE ANYTHING BELOW HERE! #######

bind pub - !stream:peak shoutinfo
bind pub - !stream:genre shoutinfo
bind pub - !stream:status shoutinfo
bind pub - !stream:track shoutinfo
bind pub - !stream:help shouthelp
bind pub - !stream shouthelp

proc shoutinfo {nick mask hand chan text} {
        global shoutpath perlbin method url lastbind

	#putlog "Called for $chan"

	set what "Stream Status"
	switch -- $lastbind {
		!stream:peak { set what "Listener Peak"; }
		!stream:genre { set what "Stream Genre" }
		!stream:track { set what "Current Song" }
	}

	# colored
	# pushmode $chan -c
	# flushmode $chan
	# set displaytext "\002\0037[string index $what 0]\00315[string range $what 1 end]: \002"

	# inverted
	set displaytext "\002\026 ~> $what:\002 "

        set f [open "|$perlbin $shoutpath $url $what"]
        set output [read $f]
        close $f
        set lines [split $output "\n"]

        foreach l $lines {
		if {[string compare $l ""] != 0} {
	                putserv "PRIVMSG $chan :$displaytext$l "
		}
        }

	# colored
	# pushmode $chan +c
	# flushmode $chan
}

proc shouthelp {nick uhost hand chan text} {
  puthelp "NOTICE $nick :\002Usage of Shout Stream Info\002"
  puthelp "NOTICE $nick :\002!stream:status\002: Current Stream Status"
  puthelp "NOTICE $nick :\002!stream:peak\002:   Listener Peak"
  puthelp "NOTICE $nick :\002!stream:genre\002:  Genre"
  puthelp "NOTICE $nick :\002!stream:track\002:  Currently played track"
  puthelp "NOTICE $nick :\002!stream:help\002:   This help screen"
}

putlog "ShoutCast Info v0.2 by Tim Niemueller \[http://www.niemueller.de\] loaded"

