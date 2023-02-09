#!/perl/bin/perl

use v5.10.0;
use strict;
use warnings;


my $a = "1";

while ($a == "1"){
	my $mobile_number = <STDIN>;	
	if ($mobile_number =~ /^[1][3,4,5,6,7,8,9][0-9]{9}$/){
		say "Oh! That's a correct phone number";
	}else {
		say "Woops!";
	}
}





