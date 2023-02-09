#!/usr/bin/perl

use strict;
use warnings;

open (INFILENAMELIST,"<$ARGV[0]") or die "$!";
open (OUT,">$ARGV[1]") or die "$!";
open (OUTERR,">$ARGV[1].error") or die "$!";
my $pace=$ARGV[2];
my %data=();
foreach my $filename(<INFILENAMELIST>){
	chomp $filename;
	open (INMETHYLCYTOSINETXT,"<$filename") or die "$!";
	foreach my $methylcytosine(<INMETHYLCYTOSINETXT>){
		chomp $methylcytosine;
		my @methylcytosine=split(/\t/,$methylcytosine);
		push @{$data{$methylcytosine[0]}{$methylcytosine[-1]}},$methylcytosine[1];
	}
}
close (INFILENAMELIST);
close (INMETHYLCYTOSINETXT);

open (INTXT,"</home/yinglu/grasscarp_reseq_8populations/linkage_groups/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
foreach my $txt(<INTXT>){
	chomp $txt;
	my @txt=split(/\t/,$txt);
	if ($txt[-1] eq "+"){
		my @count_methylated=();
		my @count_unmethylated=();
		my $data_methylated=$data{$txt[1]}{"methylated"};
		foreach my $site_methylated(@$data_methylated){
			my $i=int (($site_methylated-1)/$pace);
			$count_methylated[$i]++;
		}
		my $data_unmethylated=$data{$txt[1]}{"unmethylated"};
		foreach my $site_unmethylated(@$data_unmethylated){
			my $q=int (($site_unmethylated-1)/$pace);
			$count_unmethylated[$q]++;
		}
		my $start=();
		my $end=();
		for (my $f=0;$end<=$txt[2];$f++){
			$start=($f*$pace)+1;
			$end=($f+1)*$pace;
			if ($count_methylated[$f]){
				my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}else {
				my $result=0;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}
			if ($txt[2]-$end<=$pace){
				my $start=$end+1;
				$f=$f+1;
				if ($count_methylated[$f]){
					my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
					print OUT "$txt[0]\t$txt[1]\t$start - $txt[2]\t$result\n";
				}else {
					my $result=0;
					print OUT "$txt[0]\t$txt[1]\t$start - $txt[2]\t$result\n";
				}
			}
			last if ($txt[2]-$end<=$pace);
		}
	}elsif ($txt[-1] eq "-"){
		my @count_methylated=();
		my @count_unmethylated=();
		my $data_methylated=$data{$txt[1]}{"methylated"};
		foreach my $site_methylated(@$data_methylated){
			my $i=int (($txt[2]-$site_methylated)/$pace);
			$count_methylated[$i]++;
		}
		my $data_unmethylated=$data{$txt[1]}{"unmethylated"};
		foreach my $site_unmethylated(@$data_unmethylated){
			my $q=int (($txt[2]-$site_unmethylated)/$pace);
			$count_unmethylated[$q]++;
		}
		my $start=();
		my $end=();
		for (my $f=0;$end<=$txt[2];$f++){
			$start=($f*$pace)+1;
			$end=($f+1)*$pace;
			if ($count_methylated[$f]){
				my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}else {
				my $result=0;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}
			if ($txt[2]-$end<=$pace){
				my $start=$end+1;
				$f=$f+1;
				if ($count_methylated[$f]){
					my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
					print OUT "$txt[0]\t$txt[1]\t$start - $txt[2]\t$result\n";
				}else {
					my $result=0;
					print OUT "$txt[0]\t$txt[1]\t$start - $txt[2]\t$result\n";
				}
			}
			last if ($txt[2]-$end<=$pace);
		}
	undef @count_methylated;
	undef @count_unmethylated;
	}
}
close (INTXT);
close (OUT);
close (OUTERR);






