#!/usr/bin/perl

use strict;
use warnings;

open (INFILELIST,"<$ARGV[0]");
open (OUT,">$ARGV[1]");

my @content=();
my %count=();
my @title=qw/downstream_gene_variant initiator_codon_variant intron_variant missense_variant non_canonical_start_codon splice_acceptor_variant splice_donor_variant splice_region_variant start_lost stop_gained stop_lost stop_retained_variant synonymous_variant upstream_gene_variant/;
foreach my $infilelist(<INFILELIST>){
	chomp $infilelist;
	open (IN,"<$infilelist");
	foreach my $insnptxt(<IN>){
		chomp $insnptxt;
		next if ($insnptxt=~/^#/);
		my @insnptxt=split (/\t/,$insnptxt);
		next if ($insnptxt[1]=~/.*circ$/);
		for (my $i=8;$i<=21;$i++){
			$content[$i]+=$insnptxt[$i];
		}
	}
	$infilelist=~/\/([A-Z]{2})[_][A-Z][0-9].*/;
	print OUT "\t$1";
	splice (@content,0,8);
	for (my $q=0;$q<=13;$q++){
		push (@{$count{$title[$q]}},$content[$q]);
	}
	undef @content;
}
close (INFILELIST);
print OUT "\n";
foreach my $key(sort {$a cmp $b} keys %count){
    print OUT "$key\t";
    my $value_arr=$count{$key};
    print OUT join("\t",@$value_arr),"\n";
}
close (OUT);






