#!/usr/bin/perl

use strict;
use warnings;

my @txts_path = glob "E:/CH_NC/DMR/DSS_input_file/newLG_CH/*.txt";
foreach my $txt_path (@txts_path) {
	(my $file_name = $txt_path) =~s/.*\/(.*)\.txt/$1/;
	open (IN,"<$txt_path") or die "$!";
	open (OUT,">E:/CH_NC/DMR/DSS_input_file/newLG_CH_filtered/${file_name}_filted.txt") or die "$!";
	print OUT "chr\tpos\tN\tX\n";
	while (<IN>) {
		chomp (my $txt_data = $_);
		next if ($txt_data =~ /^chr.*/);
		my @txt_data = split (/\t/,$txt_data);
		if ($txt_data[2] >= 10) {
			print OUT "$txt_data\n";
		}
	}
}
close (IN);
close (OUT);


