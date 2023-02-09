#!/usr/bin/perl

use strict;
use warnings;

open (INTXT,"<$ARGV[0]") or die "$!";
my @matrixes_filepath = glob "$ARGV[1]/*.txt";
my $output_file = $ARGV[2];
my $column_num = $ARGV[3];
my %annotation = ();

while (<INTXT>) {
	chomp (my $annotation_data = $_);
	next unless ($annotation_data =~ /^[a-zA-Z]+/);
	my @annotation_data = split (/\t/,$annotation_data);
	my @input_column_data = split (/\|/,$annotation_data[7]);
	foreach my $input_column_data (@input_column_data) {
		unless (exists $annotation{$input_column_data}) {
			$annotation{$input_column_data} = $annotation_data[0]."_".$annotation_data[2]."_".$annotation_data[6];
		} else {
			$annotation{$input_column_data} = $annotation{$input_column_data}."|".$annotation_data[0]."_".$annotation_data[2]."_".$annotation_data[6];
		}
	}
}
close (INTXT);

foreach my $matrix_filepath (@matrixes_filepath) {
	(my $file_name = $matrix_filepath) =~ s/.*\/(.*)\.txt/$1/;
	open (INMATRIX,"<$matrix_filepath") or die "$!";
	open (OUT,">$output_file/${file_name}_KEGGannotated.txt") or die "$!";
	print OUT "#Gc geneID\tidentity\tDr geneID\tGc KEGG enrichment annotation\n";
	while (<INMATRIX>) {
		chomp (my $matrix_data = $_);
		my @matrix_data = split (/\t/,$matrix_data);
		if (exists $annotation{$matrix_data[$column_num]}) {
			print OUT "$matrix_data\t$annotation{$matrix_data[$column_num]}\n";
		} else {
			print OUT "$matrix_data\tNA\n";
		}
	}
}

close (INMATRIX);
close (OUT);

