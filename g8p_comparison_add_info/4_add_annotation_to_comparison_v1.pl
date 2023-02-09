#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open (INTXT,"<E:/Grass carp/grasscarp_8populations/kegg_KOBAS_1vs1_new/newLG/Gc_indel_output_run.txt") or die "$!";
open (INMATRIX,"<E:/ZQ_vs_AX_indel_DrPEP.txt") or die "$!";
open (OUT,">E:/t.txt") or die "$!";
my %annotation = ();

#while (<INTXT>) {
#	chomp (my $annotation_data = $_);
#	next unless ($annotation_data =~ /^[a-zA-Z]+/);
#	my @annotation_data = split (/\t/,$annotation_data);
#	my @input_column_data = split (/\|/,$annotation_data[7]);
#	foreach my $input_column_data (@input_column_data) {
#		unless (exists $annotation{$input_column_data}) {
#			$annotation{$input_column_data}{"term"} = $annotation_data[0];
#			$annotation{$input_column_data}{"ID"} = $annotation_data[2];
#			$annotation{$input_column_data}{"PCP"} = $annotation_data[6];
#		} else {
#			$annotation{$input_column_data}{"term"} = $annotation{$input_column_data}{"term"}."|".$annotation_data[0];
#			$annotation{$input_column_data}{"ID"} = $annotation{$input_column_data}{"ID"}."|".$annotation_data[2];
#			$annotation{$input_column_data}{"PCP"} = $annotation{$input_column_data}{"PCP"}."|".$annotation_data[5];
#		}
#	}
#}
#close (INTXT);
#
##my @matrixes_filepath = glob "$ARGV[0]/*.txt";
##my $column_num = $ARGV[1];
#
#print OUT "#Gc geneID\tidentity\tDr geneID\tGc KEGG term\tGc KEGG ID\tGc KEGG PCP\n";
#while (<INMATRIX>) {
#	chomp (my $matrix_data = $_);
#	my @matrix_data = split (/\t/,$matrix_data);
#	if (exists $annotation{$matrix_data[0]}) {
#		print OUT "$matrix_data\t$annotation{$matrix_data[0]}{'term'}\t$annotation{$matrix_data[0]}{'ID'}\t$annotation{$matrix_data[0]}{'PCP'}\n";
#	} else {
#		print OUT "$matrix_data\tNA\tNA\tNA\n";
#	}
#}

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

#my @matrixes_filepath = glob "$ARGV[0]/*.txt";
#my $column_num = $ARGV[1];

print OUT "#Gc geneID\tidentity\tDr geneID\tGc KEGG annotation\n";
while (<INMATRIX>) {
	chomp (my $matrix_data = $_);
	my @matrix_data = split (/\t/,$matrix_data);
	if (exists $annotation{$matrix_data[0]}) {
		print OUT "$matrix_data\t$annotation{$matrix_data[0]}\n";
	} else {
		print OUT "$matrix_data\tNA\n";
	}
}

#print OUT Dumper (\%annotation);
close (INMATRIX);
close (OUT);









