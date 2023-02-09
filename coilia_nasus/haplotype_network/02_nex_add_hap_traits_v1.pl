#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (INNEX, "<D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/haplotype_chr1_118556_128730_phased.nex") or die "$!";
open (INPOP, "<D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/pop.txt") or die "$!";
open (OUT, ">D:/research work/Coilia_nasus/3.statistics/04.haplotype_network/test1/haplotype_chr1_118556_128730_phased_input.nex") or die "$!";

my (@population_id, %population) = ();
while (<INPOP>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	$population{$data[0]} = $data[1];
	push (@population_id, $data[1]);
}
close (INPOP);

my %uniq = ();
@population_id = grep{++$uniq{$_}<2} @population_id;

my ($i, %content, @haplotype_name, %haplotype_count) = ();
while (<INNEX>) {
	chomp (my $data = $_);
	$i++;
	$content{$i} = $data;
	if ($data =~ /^\[(Hap_\d+):(.*[a-zA-Z]+.*)\]/) {
		my @data = split (/\s+/, $1.$2);
		push (@haplotype_name, $data[0]);
		foreach my $haplotype_id (@data[2..$#data]) {
			my $sample_id = substr ($haplotype_id, 0, -2);
			if ($population{$sample_id}) {
				$haplotype_count{$data[0]}{$population{$sample_id}}++;
			} else {
				print STDERR "population of $sample_id no found\n";
			}
		}
	}
}
close (INNEX);

foreach my $k (sort {$a <=> $b} keys %content) {
	print OUT "$content{$k}\n";
}

print OUT "\n\nBEGIN TRAITS;\n";
print OUT "Dimensions NTRAITS=", scalar @population_id, ";\n";
print OUT "Format labels=yes missing=? separator=Tab;\n";
print OUT "TraitLabels\t", join ("\t", @population_id), ";\n";
print OUT "Matrix\n";

foreach my $haplotype_name (@haplotype_name) {
	print OUT "$haplotype_name";
	foreach my $population_id (@population_id) {
		if ($haplotype_count{$haplotype_name}{$population_id}) {
			print OUT "\t$haplotype_count{$haplotype_name}{$population_id}";
		} else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
print OUT ";\nEnd;\n";
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;