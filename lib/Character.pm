#!/usr/bin/perl

package Character;

use strict;
use warnings;
use Term::ReadKey;
use Term::ANSIColor;
use Exporter 'import';

our @EXPORT = qw(create_player_character name_character display_faction_menu display_race_menu display_class_menu);

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

# Define character races
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

my %character_stats = (
    name     => "",
    faction  => "",
    race     => "",
    class    => "",
    charisma => 0,
    strength => 0,
    agility  => 0,
);

sub create_player_character {
    print color('blue');
    print "Welcome to Hogwrasslin' School of Wrestling and Wizardry!\n";
    print "You are about to embark on a magical journey of wrestling and wizardry.\n";
    print "But first, let's create your character.\n\n";
    print color('reset');

    my $name = name_character();
    my $faction = display_faction_menu();   
    my $race = display_race_menu();
    my $class = display_class_menu();
    my $character = update_character_stats($name, $faction, $race, $class, $charisma, $strength, $agility);
}

sub name_character {
    print color('blue');
    print "What is your character's name?\n\n";
    print color('reset');
    my $name = <STDIN>;
    chomp $name;
    print color('blue');
    print "\nWelcome, $name!\n\n";
    print color('reset');
}

sub update_character_stats {
    $character_stats{name} = shift;
    $character_stats{faction} = shift;
    $character_stats{race} = shift;
    $character_stats{class} = shift;
    $character_stats{charisma} = $faction_attributes{$character_stats{faction}}{charisma} +
                                 $race_attributes{$character_stats{race}}{charisma} +
                                 $class_attributes{$character_stats{class}}{charisma};
    $character_stats{strength} = $faction_attributes{$character_stats{faction}}{strength} +
                                 $race_attributes{$character_stats{rac}}{strength} +
                                 $class_attributes{$character_stats{class}}{strength};
    $character_stats{agility} =  $faction_attributes{$character_stats{faction}}{agility} +
                                 $race_attributes{$character_stats{race}}{agility} +
                                 $class_attributes{$character_stats{class}}{agility};
}

sub display_faction_menu {
    my $instructions = "What wizard wrestler faction do you belong to?\n" .
                       "Press 'd' to view a description of the highlighted faction.\n";
    my $selected_faction = _display_menu(\%faction_attributes, $instructions, \&get_faction_description);
    print "\nYou selected faction: $selected_faction\n";
    return \$selected_faction;
}

sub display_race_menu {
    my $instructions = "What wizard wrestler race are you?\n" .
                       "Press 'd' to view a description of the highlighted race.\n";
    my $selected_race = _display_menu(\%race_attributes, $instructions, \&get_race_description);
    print "\nYou selected race: $selected_race\n";
    return \$selected_race;
}

sub display_class_menu {
    my $instructions = "What wizard wrestler class are you?\n" .
                       "Press 'd' to view a description of the highlighted class.\n\n";
    my $selected_class = \&_display_menu(\%class_attributes, $instructions, \&get_class_description);
    print "\nYou selected class: $selected_class\n";
    return $selected_class;
}

sub _display_menu {
    my ($attributes, $instructions, $description_callback) = @_;
    my @keys = sort keys %$attributes;
    my $current_index = 0;

    ReadMode('raw');

    while (1) {
        # Full screen reset with instructions
        clear_terminal_except_last($instructions);

        # Render menu
        for my $index (0 .. $#keys) {
            if ($index == $current_index) {
                print "-> $keys[$index]\n";
            } else {
                print "   $keys[$index]\n";
            }
        }

        my $input = ReadKey(0);

        if ($input eq "\e") { # Handle arrow keys
            ReadKey(0);  # Discard '[' character in escape sequence
            my $arrow = ReadKey(0);
            if ($arrow eq "A") { # Up arrow
                $current_index-- if $current_index > 0;
            } elsif ($arrow eq "B") { # Down arrow
                $current_index++ if $current_index < $#keys;
            }
        } elsif ($input eq "d") { # Description
            my $current_key = $keys[$current_index];
            my $description = $description_callback->($current_key);
            clear_terminal_except_last("Description of $current_key:\n$description\nPress any key to return to the menu.");
            ReadKey(0);  # Wait for keypress before returning to menu
        } elsif ($input eq "\n") { # Enter key
            last;  # Exit menu
        }
    }

    ReadMode('normal');
    return $keys[$current_index];
}

sub get_faction_description {
    my ($faction) = @_;
    my $data = $faction_attributes{$faction};
    return $data->{description} . "\nBase Stats:\n" .
           "Charisma: $data->{charisma}\n" .
           "Strength: $data->{strength}\n" .
           "Agility: $data->{agility}\n";
}

sub get_race_description {
    my ($race) = @_;
    my $data = $race_attributes{$race};
    return $data->{description} . "\nBase Stats:\n" .
           "Charisma: $data->{charisma}\n" .
           "Strength: $data->{strength}\n" .
           "Agility: $data->{agility}\n";
}

sub get_class_description {
    my ($class) = @_;
    my $data = $class_attributes{$class};
    return $data->{description} . "\nBase Stats:\n" .
           "Charisma: $data->{charisma}\n" .
           "Strength: $data->{strength}\n" .
           "Agility: $data->{agility}\n";
}

sub clear_terminal_except_last {
    my ($last_message) = @_;
    print "\033[H\033[J";  # Clear the entire terminal screen
    if (defined $last_message) {
        print "$last_message\n";  # Reprint only the last message
    }
}

1;
