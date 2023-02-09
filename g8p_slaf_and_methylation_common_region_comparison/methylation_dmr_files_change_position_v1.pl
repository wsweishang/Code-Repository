#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INTXT,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";

my %order=();
foreach my $order(<INTXT>){
	chomp $order;
	next if ($order=~/^LG.*/);
	my @order=split (/\t/,$order);
	$order{$order[1]}{"LG"}=$order[0];
	$order{$order[1]}{"length"}=$order[2];
	$order{$order[1]}{"startsite"}=$order[3];
	$order{$order[1]}{"orientation"}=$order[4];
}
close (INTXT);

my @dmr_files_path=glob ("G:/1/CG_DMR/*DMR.info");
foreach my $dmr_each_file_path(@dmr_files_path){
	(my $dmr_file_name=$dmr_each_file_path)=~s/.*\/([A-Z]{2}_[A-Z]{2})_.*/$1/;
#	print "$dmr_file_name\t";
#	print "$dmr_each_file_path\n";
	open (IN,"<$dmr_each_file_path") or die "$!";
	open (OUT,">G:/$dmr_file_name.txt") or die "$!";
	foreach my $dmr_each_file_data(<IN>){
		chomp $dmr_each_file_data;
		next if ($dmr_each_file_data=~/^#.*/);
		my @dmr_each_file_data=split (/\t/,$dmr_each_file_data);
		if (exists $order{$dmr_each_file_data[0]}){
			if ($order{$dmr_each_file_data[0]}{"orientation"} eq "+"){
				$dmr_each_file_data[1]=$dmr_each_file_data[1]+$order{$dmr_each_file_data[0]}{"startsite"}-1;
				$dmr_each_file_data[2]=$dmr_each_file_data[2]+$order{$dmr_each_file_data[0]}{"startsite"}-1;
				$dmr_each_file_data[0]="LG$order{$dmr_each_file_data[0]}{'LG'}";
				print OUT join ("\t",@dmr_each_file_data),"\n";
			}elsif ($order{$dmr_each_file_data[0]}{"orientation"} eq "-"){
				$dmr_each_file_data[1]=($order{$dmr_each_file_data[0]}{"length"}-$dmr_each_file_data[1])+$order{$dmr_each_file_data[0]}{"startsite"};
				$dmr_each_file_data[2]=($order{$dmr_each_file_data[0]}{"length"}-$dmr_each_file_data[2])+$order{$dmr_each_file_data[0]}{"startsite"};
				$dmr_each_file_data[0]="LG$order{$dmr_each_file_data[0]}{'LG'}";
				print OUT join ("\t",@dmr_each_file_data),"\n";
			}
		}
	}
}

close (IN);
close (OUT);
