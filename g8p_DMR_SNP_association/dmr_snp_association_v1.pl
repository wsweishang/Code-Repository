#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
open (INVCF, "<D:/research work/Grass_carp/Methylation/association/input/SLAF_combined_filtered_snp_hard.vcf") or die "$!";
my @dmr_pathes = glob ("'D:/research work/Grass_carp/Methylation/association/input/*DML_delta01.txt'");
#map {print "$_\n"} @dmr_pathes and die;
open (OUTSNP, ">D:/research work/Grass_carp/Methylation/association/snp.txt") or die "$!";
open (OUTDMR, ">D:/research work/Grass_carp/Methylation/association/dml.txt") or die "$!";
####################################################################################################
print OUTSNP "chr\tpos\n";
while (<INVCF>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my @data = split (/\t/, $data);
	if ($data[3] eq "C" and $data[4] eq "T") {
		print OUTSNP "$data[0]\t$data[1]\n";
#		print OUTSNP substr ($data[0], 2), "\t$data[1]\n";
		next;
	}
	if ($data[3] eq "G" and $data[4] eq "A") {
		print OUTSNP "$data[0]\t$data[1]\n";
#		print OUTSNP substr ($data[0], 2), "\t$data[1]\n";
		next;
	}
}
close (INVCF);
close (OUTSNP);

print OUTDMR "chr\tpos\n";
#print OUTDMR "chr\tstart\tend\n";
foreach my $dmr_path (@dmr_pathes) {
	open (INDMR, "<$dmr_path") or die "$!";
	while (<INDMR>) {
		chomp (my $data = $_);
		next if ($data =~ /^#.*/);
		my @data = split (/\t/, $data);
		print OUTDMR "$data[0]\t$data[1]\n";
#		print OUTDMR "$data[0]\t$data[1]\t$data[2]\n";
#		print OUTDMR substr ($data[0], 2), "\t$data[1]\t$data[2]\n";
	}
	close (INDMR);
}
close (OUTDMR);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;



