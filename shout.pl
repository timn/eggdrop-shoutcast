#!/usr/bin/perl
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
# $Id: shout.pl,v 1.1 2004/01/26 00:38:46 tim Exp $
#
##############################################################################

use strict;
use LWP::UserAgent;

die "Insufficient arguments (usage: shout.pl url what" if (scalar(@ARGV) < 2);

my $url = shift;
my $what = join(" ", @ARGV);

# Create a user agent object
# Note that damn shitty ShoutCast want's standard browser here
my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla 5 ");

# Create a request
my $req = HTTP::Request->new(GET => $url);

# Pass request to the user agent and get a response back
my $res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success && ($res->code =~ /2\d\d/)) {
  my $line = $res->content;
  # $line =~ /(Stream is.*)<\/b><\/b><\/td>/;
  $line =~ /$what: <\/font><\/td><td><font class=default><b>(.*?)<\/b><\/td><\/tr>/;
  my $wanted = $1;
  $wanted =~ s/<.*?>//g;
  print "$wanted\n";
} else {
  print "Bad luck this time. Try again later.";
}

## END.
