#!/usr/bin/perl

use strict;
use warnings;

my %order=();
open (INTXT,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
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

my %dmr=();
my @dmr_files_path=glob ("G:/grasscarp_8populations/dmr_slaf_comparison/CG_DMR/*DMR.info");
foreach my $dmr_each_file_path(@dmr_files_path){
	(my $dmr_file_name=$dmr_each_file_path)=~s/.*\/([A-Z]{2}_[A-Z]{2})_.*/$1/;
	open (INDMR,"<$dmr_each_file_path") or die "$!";
	foreach my $dmr_each_file_data(<INDMR>){
		chomp $dmr_each_file_data;
		next if ($dmr_each_file_data=~/^#.*/);
		my @dmr_each_file_data=split (/\t/,$dmr_each_file_data);
		if (exists $order{$dmr_each_file_data[0]}){
			if ($order{$dmr_each_file_data[0]}{"orientation"} eq "+"){
				$dmr_each_file_data[1]=$dmr_each_file_data[1]+$order{$dmr_each_file_data[0]}{"startsite"}-1;
				$dmr_each_file_data[2]=$dmr_each_file_data[2]+$order{$dmr_each_file_data[0]}{"startsite"}-1;
				$dmr_each_file_data[0]="LG$order{$dmr_each_file_data[0]}{'LG'}";
				$dmr{$dmr_file_name}{"$dmr_each_file_data[0]"}{"$dmr_each_file_data[1]\t$dmr_each_file_data[2]"}=join (" ",@dmr_each_file_data);
			}elsif ($order{$dmr_each_file_data[0]}{"orientation"} eq "-"){
				$dmr_each_file_data[1]=($order{$dmr_each_file_data[0]}{"length"}-$dmr_each_file_data[1])+$order{$dmr_each_file_data[0]}{"startsite"};
				$dmr_each_file_data[2]=($order{$dmr_each_file_data[0]}{"length"}-$dmr_each_file_data[2])+$order{$dmr_each_file_data[0]}{"startsite"};
				$dmr_each_file_data[0]="LG$order{$dmr_each_file_data[0]}{'LG'}";
				$dmr{$dmr_file_name}{"$dmr_each_file_data[0]"}{"$dmr_each_file_data[1]\t$dmr_each_file_data[2]"}=join (" ",@dmr_each_file_data);
			}
		}
	}
}
close (INDMR);

my %result=();
my @slaf_files_path=glob ("G:/grasscarp_8populations/dmr_slaf_comparison/SLAF_Region_LG/*changedposition.txt");
foreach my $slaf_each_file_path(@slaf_files_path){
	(my $slaf_file_name=$slaf_each_file_path)=~s/.*_([a-z]+_divides_[a-z]+)_[0-9\.]+.*/$1/;
	open (INSLAF,"<$slaf_each_file_path") or die "$!";
	foreach my $slaf_each_file_data(<INSLAF>){
		chomp $slaf_each_file_data;
		next if ($slaf_each_file_data=~/^Chr.*/);
		my @slaf_each_file_data=split (/\t/,$slaf_each_file_data);
		foreach my $key1(keys %dmr){
			foreach my $key3(keys %{$dmr{$key1}{$slaf_each_file_data[0]}}){
				my @position=split (/\t/,$key3);
				my $left=$position[1]-$slaf_each_file_data[1];
				my $right=$position[0]-$slaf_each_file_data[2];
				
				if ($left>0 and $right<0){
					my @temporary=($position[0],$position[1],$slaf_each_file_data[1],$slaf_each_file_data[2]);
					@temporary=sort @temporary;
					my $range=$temporary[2]-$temporary[1]+1;
					my $overlap_rate_in_dmr=$range/($position[1]-$position[0]+1);
					my $overlap_rate_in_slaf=$range/($slaf_each_file_data[2]-$slaf_each_file_data[1]+1);
					$result{"$key1\t$slaf_file_name"}{"$slaf_each_file_data[0]"}{"$range"}="$key1\t$slaf_file_name\t$slaf_each_file_data[0]\t$range\t$overlap_rate_in_dmr\t$overlap_rate_in_slaf\t$dmr{$key1}{$slaf_each_file_data[0]}{$key3}\t".join(" ",@slaf_each_file_data);
					undef @temporary;
				}
			}
		}
	}
}
close (INSLAF);

open (OUT,">G:/grasscarp_8populations/dmr_slaf_comparison/dmr_slaf_comparison_v1.txt") or die "$!";
print OUT "DMR file\tSLAF file\tLG number\toverlap length\toverlap rate in dmr\toverlap rate in slaf\tDMR file content\tSLAF file content\n";
foreach my $key1(sort {$a cmp $b} keys %result){
	foreach my $key2(sort {$a cmp $b} keys %{$result{$key1}}){
		foreach my $key3(sort {$a <=> $b} keys %{$result{$key1}{$key2}}){
			print OUT "$result{$key1}{$key2}{$key3}\n";
		}
	}
}
close (OUT);
