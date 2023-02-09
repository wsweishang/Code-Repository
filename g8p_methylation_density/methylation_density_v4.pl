#!/usr/bin/perl

use strict;
use warnings;

open (INTXT,"<G:/1.gff") or die "$!";
open (INMETHYLCYTOSINETXT,"<G:/1.txt") or die "$!";
open (OUT,">G:/test.txt") or die "$!";
my $pace=10000;

my %LG=();
my %content=();
my @order=();
my $fh=0;
foreach my $txt(<INTXT>){
	chomp $txt;
	next if ($txt=~/^LG.*/);
	my @txt=split(/\t/,$txt);
	push @order,$txt[0] if ($fh != $txt[0]);
	$fh=$txt[0];
	$content{$txt[1]}{"LG"}=$txt[0];
	$content{$txt[1]}{"length"}=$txt[2];
	$content{$txt[1]}{"startsite"}=$txt[3];
	$content{$txt[1]}{"orientation"}=$txt[-1];
	$LG{"LG$txt[0]"}=$txt[3]+$txt[2]-1;
}
close (INTXT);

my %data=();
foreach my $methylcytosine(<INMETHYLCYTOSINETXT>){
	chomp $methylcytosine;
	my @methylcytosine=split(/\t/,$methylcytosine);
	my $LG_ID=$content{$methylcytosine[0]}{"LG"};
	if (exists $content{$methylcytosine[0]}){
		if ($content{$methylcytosine[0]}{"orientation"} eq "+"){
			my $site=$content{$methylcytosine[0]}{"startsite"}+$methylcytosine[1]-1;
			push @{$data{"LG$LG_ID"}{$methylcytosine[-1]}},$site;
		}elsif ($content{$methylcytosine[0]}{"orientation"} eq "-"){
			my $site=$content{$methylcytosine[0]}{"length"}-$methylcytosine[1]+$content{$methylcytosine[0]}{"startsite"};
			push @{$data{"LG$LG_ID"}{$methylcytosine[-1]}},$site;
		}
	}
}
close (INMETHYLCYTOSINETXT);

foreach my $LG_ID(@order){
	my $length=$LG{"LG$LG_ID"};
	my @count_methylated=();
	my @count_unmethylated=();
	my $data_methylated=$data{"LG$LG_ID"}{"methylated"};
	foreach my $site_methylated(@$data_methylated){
		my $i=int (($site_methylated-1)/$pace);
		$count_methylated[$i]++;
	}
	my $data_unmethylated=$data{"LG$LG_ID"}{"unmethylated"};
	foreach my $site_unmethylated(@$data_unmethylated){
		my $q=int (($site_unmethylated-1)/$pace);
		$count_unmethylated[$q]++;
	}
	my $start=();
	my $end=0;
	for (my $f=0;$end<=$length;$f++){
		$start=($f*$pace)+1;
		$end=($f+1)*$pace;
		if ($count_methylated[$f]){
			my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
			$result=sprintf "%.4f",$result;
			print OUT "LG$LG_ID\t$start - $end\t$result\n";
		}else {
			my $result=0;
			$result=sprintf "%.4f",$result;
			print OUT "LG$LG_ID\t$start - $end\t$result\n";
		}
		if ($length-$end<=$pace){
			my $start=$end+1;
			$f=$f+1;
			if ($count_methylated[$f]){
				my $result=$count_methylated[$f]/($count_methylated[$f]+$count_unmethylated[$f]);
				$result=sprintf "%.4f",$result;
				print OUT "LG$LG_ID\t$start - $length\t$result\n";
			}else {
				my $result=0;
				$result=sprintf "%.4f",$result;
				print OUT "LG$LG_ID\t$start - $length\t$result\n";
			}
		}
		last if ($length-$end<=$pace);
	}
	undef @count_methylated;
	undef @count_unmethylated;
}
close (OUT);


