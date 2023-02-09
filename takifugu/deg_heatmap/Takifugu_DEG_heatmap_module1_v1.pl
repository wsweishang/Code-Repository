#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
####################################################################################################
my $output_dir = "D:/research work/Takifugu/RNAseq/03.statistics/07.heatmap/";
####################################################################################################
my (%order, %deg) = ();
while (<DATA>) {
	chomp (my $data = $_);
	next if ($data =~ /^#.*/);
	my ($population, $organ, $temprature, $path) = split (/\t/, $data);
	push (@{$order{$organ}}, "${population}_${temprature}");
	open (INDEG, "<$path") or die "$!";
	while (<INDEG>) {
		chomp (my $data = $_);
		next if ($data =~ /^test_id.*/);
		my @data = split (/\t/, $data);
		my ($gene_id, $gene_name, $value_1, $value_2, $fold_change, $p_value, $q_value) = @data[1, 2, 7, 8, 9, 11, 12];
		if ($fold_change =~ /.*inf.*/) {
			$value_1 = ($value_1 == 0) ? 0.1 : $value_1;
			$value_2 = ($value_2 == 0) ? 0.1 : $value_2;
			$fold_change = log($value_2 / $value_1) / log(2);
		}
		$deg{$organ}{"${gene_id}\t${gene_name}"}{"${population}_${temprature}"} = "$value_1\t$value_2\t$fold_change\t$p_value\t$q_value";
	}
}
close (INDEG);
close (DATA);

foreach my $organ (sort {$a cmp $b} keys %deg) {
	open (OUT, ">${output_dir}Fugu_DEG_cuffdiff_${organ}.txt") or die "$!";
	my @b = qw/value_1 value_2 fold_change p_value q_value/;
	my @order = @{$order{$organ}};
	my @title = glob "{@{[join ',', @order]}}_{@{[join ',', @b]}}";
	print OUT "#gene_id\tgene_name\t", join("\t", @title), "\n";
	foreach my $gene_name (sort {$a cmp $b} keys %{$deg{$organ}}) {
		print OUT "$gene_name";
		foreach my $order (@order) {
			print OUT "\t$deg{$organ}{$gene_name}{$order}";
		}
		print OUT "\n";
	}
}
close (OUT);
####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__
#population	organ	temprature	path
TA	Brain	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_brain_04_vs_TA_brain_24/gene_exp.diff
TA	Brain	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_brain_07_vs_TA_brain_24/gene_exp.diff
TA	Brain	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_brain_16_vs_TA_brain_24/gene_exp.diff
TA	Gill	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_gill_04_vs_TA_gill_24/gene_exp.diff
TA	Gill	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_gill_07_vs_TA_gill_24/gene_exp.diff
TA	Gill	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_gill_16_vs_TA_gill_24/gene_exp.diff
TA	Int	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_int_04_vs_TA_int_24/gene_exp.diff
TA	Int	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_int_07_vs_TA_int_24/gene_exp.diff
TA	Int	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_int_16_vs_TA_int_24/gene_exp.diff
TA	Liver	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_liver_04_vs_TA_liver_24/gene_exp.diff
TA	Liver	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_liver_07_vs_TA_liver_24/gene_exp.diff
TA	Liver	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TA_liver_16_vs_TA_liver_24/gene_exp.diff
TU	Brain	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_brain_04_vs_TU_brain_24/gene_exp.diff
TU	Brain	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_brain_07_vs_TU_brain_24/gene_exp.diff
TU	Brain	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_brain_16_vs_TU_brain_24/gene_exp.diff
TU	Gill	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_gill_04_vs_TU_gill_24/gene_exp.diff
TU	Gill	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_gill_07_vs_TU_gill_24/gene_exp.diff
TU	Gill	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_gill_16_vs_TU_gill_24/gene_exp.diff
TU	Int	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_int_04_vs_TU_int_24/gene_exp.diff
TU	Int	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_int_07_vs_TU_int_24/gene_exp.diff
TU	Int	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_int_16_vs_TU_int_24/gene_exp.diff
TU	Liver	04	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_liver_04_vs_TU_liver_24/gene_exp.diff
TU	Liver	07	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_liver_07_vs_TU_liver_24/gene_exp.diff
TU	Liver	16	D:/research work/Takifugu/RNAseq/03.statistics/01.Cufflink/cuffdiff/TU_liver_16_vs_TU_liver_24/gene_exp.diff