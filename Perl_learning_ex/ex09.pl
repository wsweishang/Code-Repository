#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;

say "Please print a number:\nYou have 5 chances";


my $answer = "26";
my $cnt = "0";

while ($cnt < 5){
	my $cnt2 = 5 - $cnt;
	$cnt++;
	say "Now you have $cnt2 chances";
	my $input = <STDIN>;
	if ($input < $answer){
		say "too low";
	}
	elsif ($input > $answer){
		say "too high";
	}
	else {
		say "right";
		last;
	}
}
