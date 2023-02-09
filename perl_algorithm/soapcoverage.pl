#!/usr/bin/env perl 

use strict;
use warnings;

die "Usage: perl $0 <in.file>\n" unless @ARGV eq 1;
 
my ($in)=@ARGV;
my ($chr)=$in=~/(\w+)\.coverage/;
 
my ($end,$type,$type_site);
open IN,(($in=~/\.gz$/)?"gzip -dc $in |":$in) or die $!;
$end=0;
<IN>;
 
chomp (my $line=<IN>);
my @tmp=split (/\s+/,$line);
print "$chr\t$end\t";
$tmp[0]>0?($type=1):($type=0);
my ($sum,$peak)=($tmp[0],$tmp[0]);
($sum,$peak,$end,$type)=&set_region($sum,$peak,$end,$type,@tmp[1..$#tmp]);
 
while(<IN>){
	chomp;
	@tmp=split;
	($sum,$peak,$end,$type)=&set_region($sum,$peak,$end,$type,@tmp);
}
close IN;
print "$end\t$sum\t$peak\n";
 
sub set_region{
	my ($sum,$peak,$end,$type,@tmp)=@_;
	my $type_site;
	foreach my $site(@tmp){
		$end++;
		$type_site=$site>0?1:0;
		if ($type==$type_site){
			$sum+=$site;
			$peak=$site if ($site>$peak);
			next;
		}
		my $end_before=$end-1;
		print "$end_before\t$sum\t$peak\n$chr\t$end\t";
		($sum,$peak)=($site,$site);
		$type=$type_site;
	}
	return ($sum,$peak,$end,$type);
}
		
		
		
		
		
		
		