#!/usr/bin/perl

use strict;
use warnings;

open (INXML, "<D:/AX_vs_VN_AF005AN80FS60DP80_100kb_top005_gene_nr.txt") or die "$!";
open (OUT, ">D:/t.txt") or die "$!";

local $/ = "</Iteration>";

while (<INXML>) {
	my $content = $_;
	my $query_num = $1 if ($content =~ /<Iteration_iter-num>(\S+)<\/Iteration_iter-num>/);
	my $query_id = $1 if ($content =~ /<Iteration_query-def>(\S+)<\/Iteration_query-def>/);
	while ($content =~ /<Hit>(.*?)<\/Hit>/sg) {
		chomp (my $hit = $1);
		next if ($hit !~ /<Hit_num>1<\/Hit_num>/);
		my $id = $1 if ($hit =~ /<Hit_id>(\S+)<\/Hit_id>/);
		my $def = $1 if ($hit =~ /<Hit_def>(.*?)<\/Hit_def>/);
		print OUT "$query_num\t$query_id\t$id\t$def\n";
    }
}
close (INXML);
close (OUT);








