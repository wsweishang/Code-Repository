#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INGC,"<G:/Query_Grasscarp_blastpwith_Subject_Daniorerio_1e10_m8_20190807.output_coverage_index_sorted_top") or die "$!";
open (INDR,"<G:/Query_Daniorerio_blastpwith_Subject_Grasscarp_1e10_m8_20190808.output_coverage_index_sorted_top") or die "$!";
open (OUT,">G:/2.txt") or die "$!";

my %gc=();
foreach my $ingc(<INGC>){
	chomp $ingc;
	next if ($ingc!~/^CI.*/);
	my @ingc=split (/\t/,$ingc);
	$gc{$ingc[1]}{$ingc[2]}=$ingc[5];
}
close (INGC);
#print OUT Dumper (\%gc);

my %dr=();
foreach my $indr(<INDR>){
	chomp $indr;
	next if ($indr!~/^EN.*/);
	my @indr=split (/\t/,$indr);
	$dr{$indr[2]}{$indr[1]}=$indr[5];
}
close (INDR);
#print OUT Dumper (\%dr);

my %hash=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file(@files){
	open (IN,"<$file") or die "$!";
	foreach my $content(<IN>){
		chomp $content;
		next if ($content=~/^#.*/);
		my @content_splited=split(/\t/,$content);
		next if ($content_splited[1]=~/.*circ$/);
		$hash{$content_splited[0]}="NA";
	}
}

foreach my $k1(keys %hash){
	if (exists $gc{$k1}){
		my @m=%{$gc{$k1}};
		print OUT "@m\n";
#		if (exists $dr{$k1}{$m}){
#			print OUT "$k1\t$dr{$k1}{$m}\t$gc{$k1}{$m}\t$m\n";
#		}
#		else{
#			print OUT "$k1\tNA\tNA\tNA\tNA\n";
#		}
	}
#	else{
#		print OUT "$k1\tNA\tNA\tNA\tNA\n";
#	}
}



