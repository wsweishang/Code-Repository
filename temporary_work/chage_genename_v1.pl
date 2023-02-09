#!/usr/bin/perl

use strict;
use warnings;

open (INVCF, "<E:/GCF_000735185.1_NC01_genomic.gff") or die "$!";
open (OUT, ">E:/new.gff") or die "$!";

my $head = ();
my $transcript = ();
while (<INVCF>) {
	my $vcf_data = $_;
	if ($vcf_data =~ /.*_id=([^;]+).*/) {
		my $transcript = $1;
		chomp ($transcript);
		$vcf_data =~ s/(.*gene=)[^;]+(.*)/$1$transcript$2/;
	} else {
		$head .= $vcf_data;
		next;
	}
	if ($head) {
		$head =~ s/(.*NAME=)[^;]+(.*)/$1$transcript$2/;
		print OUT $head;
		undef $head;
	}
	print OUT $vcf_data;
	undef ($transcript);
}














close (INVCF);
close (OUT);
