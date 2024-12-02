#!/usr/bin/perl

use strict;
use warnings;
use Term::ReadKey;
use Term::ANSIColor;
use FindBin;
use lib "$FindBin::Bin/lib";
use Character;
use Data::Dumper;


print "Script is running from: $FindBin::Bin\n";


## This is the main file for the game. It will handle the game loop and the main game logic.

create_player_character();

