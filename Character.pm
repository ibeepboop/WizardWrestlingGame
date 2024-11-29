#!/usr/bin/perl

package Character;

use strict;
use warnings;
use Term::ReadKey;
use Term::ANSIColor;

# Define character factions
my %faction_attributes = (
    "Babyface" => {
        charisma    => 10,
        strength    => 10,
        agility     => 10,
        description => "The good guys, fighting for justice and honor.",
    },
    "Heel" => {
        charisma    => 10,
        strength    => 10,
        agility     => 10,
        description => "The bad guys, fighting for power and glory.",
    },
);

my %race_attributes = (
    "Flairborn" => {
        charisma    => 15,
        strength    => 8,
        agility     => 10,
        description => "Charismatic and crowd-driven, inspired by Ric Flair.",
    },
    "Highstriders" => {
        charisma    => 10,
        strength    => 10,
        agility     => 15,
        description => "Agile and quick, inspired by highflyers like Jeff Hardy.",
    },
    "Coldforged" => {
        charisma    => 8,
        strength    => 15,
        agility     => 8,
        description => "Resilient and durable, inspired by Stone Cold Steve Austin.",
    },
    "Giantkin" => {
        charisma    => 5,
        strength    => 20,
        agility     => 5,
        description => "Imposing and strong, inspired by Andre the Giant.",
    },
    "Gravekeepers" => {
        charisma    => 12,
        strength    => 10,
        agility     => 10,
        description => "Dark and mysterious, inspired by The Undertaker.",
    },
    "Savagefire" => {
        charisma    => 10,
        strength    => 12,
        agility     => 13,
        description => "Fiery and intense, inspired by Macho Man Randy Savage.",
    },
);

# Define character classes
my %class_attributes = (
    "Highflyer" => {
        charisma    => 10,
        strength    => 8,
        agility     => 15,
        description => "Agile and quick, inspired by highflyers like Jeff Hardy.",
    },
    "Powerhouse" => {
        charisma    => 8,
        strength    => 15,
        agility     => 8,
        description => "Resilient and durable, inspired by Stone Cold Steve Austin.",
    },
    "Technician" => {
        charisma    => 12,
        strength    => 10,
        agility     => 10,
        description => "Technical and skilled, inspired by Bret Hart.",
    },
    "Showman" => {
        charisma    => 15,
        strength    => 8,
        agility     => 10,
        description => "Charismatic and crowd-driven, inspired by Ric Flair.",
    },
);

sub create_player_character {
    print color('blue');
    print "Welcome to Hogwrasslin’ School of Wrestling and Wizardry!\n";
    print "You are about to embark on a magical journey of wrestling and wizardry.\n";
    print "But first, let’s create your character.\n";
    print color('reset');
    name_character();
    display_faction_menu();
    display_race_menu();
    display_class_menu();
}

sub name_character {
    print color('blue');
    print "What is your character's name?\n\n";
    print color('reset');
    my $name = color('bold green') . <STDIN> . color('reset');
    chomp $name;
    print color('blue');
    print "Welcome, $name!\n\n";
    print color('reset');
}

sub display_faction_menu {
    my $current_faction_array_index = 0;

    print color('blue');
    print "What wizard wrestler faction do you belong to?\n";
    print "Press 'd' to view a description of the highlighted faction.\n\n";
    print color('reset');

    my @factions = sort keys %faction_attributes;
    my $current_index = 0;

    ReadMode('raw');

    while (1) {
        # Render the menu
        for my $index (0..$#factions) {
            if ($index == $current_index) {
                print "-> $factions[$index]\n";
            } else {
                print "   $factions[$index]\n";
            }
        }

        my $input = ReadKey(0);

        if ($input eq "\e") { # Arrow keys
            ReadKey(0);
            my $arrow = ReadKey(0);
            if ($arrow eq "A") { # Up arrow
                $current_index-- if $current_index > 0;
            } elsif ($arrow eq "B") { # Down arrow
                $current_index++ if $current_index < $#factions;
            }
        } elsif ($input eq "d") {
            my $current_faction = $factions[$current_index];
            print "\nDescription of $current_faction:\n";
            print get_faction_description($current_faction) . "\n";
            print "Press any key to return to the menu.\n";
            ReadKey(0);
        } elsif ($input eq "\n") { # Enter key
            last;
        }
        # Clear the menu before re-rendering
        for (1 .. @factions) {
            print "\033[F\033[K";  # Move cursor up and clear the line
        }
    }

    ReadMode('normal');

    # Final faction selection
    my $selected_faction = $factions[$current_index];
    print "\nYour selected faction: $selected_faction\n\n";
    return $selected_faction;
}

sub display_race_menu {
    my $current_race_array_index = 0;

    print color('blue');
    print "What wizard wrestler race are you?\n";
    print "Press 'd' to view a description of the highlighted race.\n\n";
    print color('reset');

    my @races = sort keys %race_attributes;
    my $current_index = 0;

    ReadMode('raw');

    while (1) {
        for my $index (0..$#races) {
            if ($index == $current_index) {
                print "-> $races[$index]\n";
            } else {
                print "   $races[$index]\n";
            }
        }

        my $input = ReadKey(0);

        if ($input eq "\e") { # Arrow keys accepted now
            ReadKey(0);
            my $arrow = ReadKey(0);
            if ($arrow eq "A") { # Up arrow
                $current_index-- if $current_index > 0;
            } elsif ($arrow eq "B") { # Down arrow
                $current_index++ if $current_index < $#races;
            }
        } elsif ($input eq "d") {
            my $current_race = $races[$current_index];
            print "\nDescription of $current_race:\n";
            print get_race_description($current_race) . "\n";
            print "Press any key to return to the menu.\n";
            ReadKey(0);
        } elsif ($input eq "\n") { # Enter key
            last;
        }

        # Clear the menu before re-rendering
        for (1 .. @races) {
            print "\033[F\033[K";  # Move cursor up and clear the line
        }
    }

    ReadMode('normal');

    # Final race selection
    my $selected_race = $races[$current_index];
    print "\nYour selected race: $selected_race\n\n";
    return $selected_race;
} 

sub display_class_menu {
    my $current_class_array_index = 0;

    print color('blue');
    print "What wizard wrestler class are you?\n";
    print "Press 'd' to view a description of the highlighted class.\n\n";
    print color('reset');

    my @classes = sort keys %class_attributes;
    my $current_index = 0;

    ReadMode('raw');

    while (1) {
        for my $index (0..$#classes) {
            if ($index == $current_index) {
                print "-> $classes[$index]\n";
            } else {
                print "   $classes[$index]\n";
            }
        }

        my $input = ReadKey(0);

        if ($input eq "\e") { # Arrow keys accepted now
            ReadKey(0);
            my $arrow = ReadKey(0);
            if ($arrow eq "A") { # Up arrow
                $current_index-- if $current_index > 0;
            } elsif ($arrow eq "B") { # Down arrow
                $current_index++ if $current_index < $#classes;
            }
        } elsif ($input eq "d") {
            my $current_class = $classes[$current_index];
            print "\nDescription of $current_class:\n";
            print get_class_description($current_class) . "\n";
            print "Press any key to return to the menu.\n";
            ReadKey(0);
        } elsif ($input eq "\n") { # Enter key
            last;
        }

        # Clear the menu before re-rendering
        for (1 .. @classes) {
            print "\033[F\033[K";  # Move cursor up and clear the line
        }
    }

    ReadMode('normal');

    # Final class selection
    my $selected_class = $classes[$current_index];
    print "\nYour selected class: $selected_class\n\n";
    return $selected_class;
}

sub get_faction_description {
    my ($faction) = @_;
    my $data = $faction_attributes{$faction};
    return $data->{description} . "\nBase Stats: " . 
        "\nCharisma: $data->{charisma} " .
        "\nStrength: $data->{strength} " .
        "\nAgility: $data->{agility}\n";
}

sub get_race_description {
    my ($race) = @_;
    my $data = $race_attributes{$race};
    return $data->{description} . "\nBase Stats: " . 
        "\nCharisma: $data->{charisma} " .
        "\nStrength: $data->{strength} " .
        "\nAgility: $data->{agility}\n";
}

sub get_class_description {
    my ($class) = @_;
    my $data = $class_attributes{$class};
    return $data->{description} . "\nBase Stats: " . 
        "\nCharisma: $data->{charisma} " .
        "\nStrength: $data->{strength} " .
        "\nAgility: $data->{agility}\n";
}

1;