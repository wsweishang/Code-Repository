#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;
#use Data::Dumper;

open (INGFF,"</home/yinglu/grasscarp_reseq_8populations/linkage_groups/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff") or die "$!";
open (OUT,">check_gff_exists_duplication.txt") or die "$!";

{
	my %check=();
	local $/="gene";
	foreach my $gff(<INGFF>){
		my @gff=split(/\n/,$gff);
		my $end=pop @gff;
		$gff[0]=$end.$gff[0];
		next if ($gff[0]=~/region/);
	#	print OUT "@gff\n";
		my %count=();
		my @comm_times=grep {++$count{$_}>=2;} @gff;
		print OUT "error! duplication:@gff\n" if (@comm_times);
		$gff[0]=~/Name=([0-9a-zA-Z_]+)$/;
		my $ID=$1;
		print OUT "error! existed:$gff\n" if (exists $check{$ID});
		$check{$ID}="existed";
		undef @comm_times;
	}
}


close (INGFF);
close (OUT);



