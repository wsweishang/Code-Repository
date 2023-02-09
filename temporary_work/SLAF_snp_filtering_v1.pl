#!/usr/bin/perl

use strict;
use warnings;

open (INFQ, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";
my $threshold = $ARGV[2];

my $str = ();
for (my $i = 0; $i < $threshold ; $i++) {
	$str .= chr ($i + 33);
}

while (<INFQ>) {
	chomp (my $fq_first_line = $_);
	chomp (my $fq_second_line = <INFQ>);
	chomp (my $fq_third_line = <INFQ>);
	chomp (my $fq_fourth_line = <INFQ>);
	my $fq_second_line_length = length $fq_second_line;
	my $fq_second_line_count = ($fq_second_line =~ s/N/N/g);
	my $fq_fourth_line_length = length $fq_fourth_line;
	$_ = $fq_fourth_line;
	my $fq_fourth_line_count = (eval "tr/$str//");
	my $a = $fq_second_line_count / $fq_second_line_length;
	my $b = $fq_fourth_line_count / $fq_fourth_line_length;
#	print "$fq_second_line_count\t$fq_fourth_line_count\t$a\t$b\n";
	next if ($a >= 0.1 or $b >= 0.5);
	print OUT "$fq_first_line\n";
	print OUT "$fq_second_line\n";
	print OUT "$fq_third_line\n";
	print OUT "$fq_fourth_line\n";
}

close (INFQ);
close (OUT);



