#!/usr/bin/perl

use strict;
use warnings;

open (SAM, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";

my %length = ();
my %sam = ();
my $all_reads = ();
while (<SAM>) {
	chomp (my $sam = $_);
	if ($sam =~ /^\@.*/) {
#		if ($sam =~ /^\@SQ.*/) {
#			my @sam = split (/\t\:+/, $sam);
#			$sam =~ /^\@SQ\tSN:(\S+)\tLN:(\d+)/;
#			$length{$1} = $2;
#		}
		next;
	} else {
		my @sam = split (/\t/, $sam);
		next if ($sam[2] eq "*");
		$sam{$sam[2]}++;
		$all_reads++;
#		print "$sam[2]\t$sam{$sam[2]}\t$all_reads\n" and die;
	}
}
close (SAM);

foreach my $TE (sort %sam) {
#	my $result = $sam{$TE} / ($all_reads * $length{$TE});
#	print OUT "$TE\t$sam{$TE}\t$all_reads\t$length{$TE}\n";
	print OUT "$TE\t$sam{$TE}\n";
}
close (OUT);

#my $a = 141;
#my @result = &FLAG ($a, 0);
#print "@result\n";
#my @flag = qw/2048 1024 512 256 128 64 32 16 8 4 2 1/;
#
#
#sub FLAG {
#	my ($number, $i) = $_[0];
#	if ($number >= $flag[$i]) {
#		push (@result, $flag[$i]);
#		$number = $number - $flag[$i];
#		my $result
#	} else {
#		return ();
#		
#		
#		
#		
#		
#	}
#	
#	
#	
#	
#	
#	
#	
#	
#}



