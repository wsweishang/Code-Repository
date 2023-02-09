#!/usr/bin/perl

use strict;
use warnings;

open (INTXT,"<E:/CH_NC/DMR/DSS_input_file/newLG_CH_2_skin_R1_val_1_allLG.txt") or die "$!";
#my @lg = qw/LG1 LG2 LG3 LG4 LG5 LG6 LG7 LG8 LG9 LG10 LG11 LG12 LG13 LG14 LG15 LG16 LG17 LG18 LG19 LG20 LG21 LG22 LG23 LG24/;
my %hash = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^chr.*/);
	my @txt_data = split (/\t/,$txt_data);
	$hash{$txt_data[0]}{$txt_data[1]} = $txt_data;
}
close (INTXT);

foreach my $key1 (keys %hash) {
	open (OUT,">E:/CH_NC/DMR/DSS_input_file/newLG_CH_2_skin/CH_2_skin_${key1}.txt") or die "$!";
	print OUT "chr\tpos\tN\tX\n";
	foreach my $key2 (sort {$a <=> $b} keys %{$hash{$key1}}) {
		print OUT "$hash{$key1}{$key2}\n";
	}
}
close (OUT);







