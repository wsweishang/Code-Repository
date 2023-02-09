#!/usr/bin/perl

use strict;
use warnings;

open (LIST, "<$ARGV[0]") or die "$!";
open (OUT, ">$ARGV[1]") or die "$!";

my %list_data = ();
while (<LIST>) {
	chomp (my $list_data = $_);
	my @list_data = split (/\t/, $list_data);
	for (my $i = 2 ; $i <= $#list_data ; $i++) {
		push (@{$list_data{$list_data[0]}{$list_data[1]}}, $list_data[$i]);
	}
	$list_data{$list_data[0]}{$list_data[1]}{"diploid"} = ($#list_data - 1) * 2;
}
close (LIST);

my %vcf_data = ();
my %snp_site = ();

foreach my $group (keys %list_data) {
	foreach my $population (keys %{$list_data{$group}}) {
		foreach my $indivadual (@{$list_data{$group}{$population}}) {
			open (VCF, "<$indivadual") or die "$!";
			while (<VCF>) {
				chomp (my $vcf_data = $_);
				next if ($vcf_data =~ /^#.*/);
				my @vcf_data = split (/\t/, $vcf_data);
				my @format_data = split (/\:/, $vcf_data[8]);
				my @sample_data = split (/\:/, $vcf_data[9]);
				my %format = ();
				for (my $i = 0 ; $i <= $#format_data ; $i++) {
					$format{$format_data[$i]} = $sample_data[$i];
				}
				
				if ($format{"GT"} eq "0/1") {
					$vcf_data{$vcf_data[0]}{$vcf_data[1]}{$vcf_data[4]}{"$population"}++;
				} elsif ($format{"GT"} eq "1/1") {
					$vcf_data{$vcf_data[0]}{$vcf_data[1]}{$vcf_data[4]}{"$population"}++;
					$vcf_data{$vcf_data[0]}{$vcf_data[1]}{$vcf_data[4]}{"$population"}++;
				} else {
					print "error\n" and die;
				}
				$snp_site{$vcf_data[0]}{$vcf_data[1]} = 1;
			}
		}
	}
}
close (VCF);




foreach my $key1 (keys %snp_site) {
	foreach my $key2 (sort (keys %{$snp_site{$key1}})) {
		
	}
}




#!/usr/bin/perl
use strict;
use Data::Dumper;
#my ($a,$b) = @ARGV;
$a='gene.txt';
#$b = 'hweout_rs';
my %hash;
open A,"$a" or die;
my $head = <A>;
chomp $head;
my @line1=split/\t/,$head;
while(<A>){
    chomp;
    my @t=split/\t/,$_;
    for my $i (1 .. $#t){
        my @geno = split//,$t[$i];
        my @st = sort{$a cmp $b } @geno;
        my $nsc=$st[0].$st[1];
        $hash{$line1[$i]}{$st[0]} +=1;
        $hash{$line1[$i]}{$st[1]} +=1;
    }
}
#print Dumper(\%hash);
for my $rs(sort keys %hash){
    for my $key(sort keys %{$hash{$rs}}){
        print "$rs\t$key\t$hash{$rs}{$key}\n";
    }
}










close (OUT);