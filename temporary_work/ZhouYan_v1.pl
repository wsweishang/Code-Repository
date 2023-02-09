#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (INDESEQ, "<D:/research work/ZhouYan/32vs28_deseq2_output_all.txt") or die "$!";
open (INCOUNT, "<D:/research work/ZhouYan/total_count.txt") or die "";
open (INANNO, "<D:/research work/ZhouYan/fpkm.anno.txt") or die "$!";
open (OUT, ">D:/research work/ZhouYan/t.txt") or die "$!";

my @sample_id = qw/Normo281 Normo282 Hypo287 Normo321 Normo322 Hypo325/;

my (@deseq_header, %deseq, %updown, %significant) = ();
while (<INDESEQ>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	if ($data =~ /^Row\.names.*/) {
		@deseq_header = @data;
		next;
	}
	$deseq{$data[0]} = join ("\t", @data[1..6]);
	
	if ($data[6] ne "NA") {
		if ($data[6] <= 0.05) {
			$significant{$data[0]} = "significant";
		} else {
			$significant{$data[0]} = "unsignificant";
		}
	} else {
		$significant{$data[0]} = "NA";
	}
	
	if ($data[2] ne "NA") {
		if ($data[2] < 0) {
			$updown{$data[0]} = "down";
		} else {
			$updown{$data[0]} = "up";
		}
	} else {
		$updown{$data[0]} = "NA";
	}
}
close (INDESEQ);

my (@count_header, %count) = ();
while (<INCOUNT>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	if ($data =~ /^name.*/) {
		@count_header = @data;
		next;
	}
	map {$count{$data[0]}{$count_header[$_]} = $data[$_]} 0..$#count_header;
}
close (INCOUNT);

my (@anno_header, %anno) = ();
while (<INANNO>) {
	chomp (my $data = $_);
	my @data = split (/\t/, $data);
	if ($data =~ /^name.*/) {
		@anno_header = @data;
		next;
	}
	$anno{$data[0]} = join ("\t", @data[12..$#anno_header]);
}
close (INANNO);

print OUT "#name\t", join ("\t", @sample_id), "\t", join ("\t", @deseq_header[1..6]), "\tUp/Down\tSignificant\t", join ("\t", @anno_header[12..$#anno_header]), "\n";

foreach my $gene_id (sort {$a cmp $b} keys %anno) {
	print OUT "$gene_id\t";
	map {print OUT "$count{$gene_id}{$_}\t"} @sample_id;
	print OUT "$deseq{$gene_id}\t";
	print OUT "$updown{$gene_id}\t";
	print OUT "$significant{$gene_id}\t";
	print OUT "$anno{$gene_id}\n";
}
close (OUT);


































#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;