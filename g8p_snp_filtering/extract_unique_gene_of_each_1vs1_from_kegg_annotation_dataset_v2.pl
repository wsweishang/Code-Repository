#!/usr/bin/perl

use strict;
use warnings;

my %gc_blastp_dr_data=();
open (INBLASTP,"</home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/g8p_snp_blastp/mutural_blastp/Query_Grasscarp_blastpwith_Subject_Daniorerio_1e10_m8_20190807.output_coverage_index_sorted_top");
foreach my $gc_blastp_dr_data(<INBLASTP>){
	chomp $gc_blastp_dr_data;
	my @gc_blastp_dr_data=split (/\t/,$gc_blastp_dr_data);
	$gc_blastp_dr_data{$gc_blastp_dr_data[1]}{"identity_ratio"}=$gc_blastp_dr_data[5];
	$gc_blastp_dr_data{$gc_blastp_dr_data[1]}{"subject"}=$gc_blastp_dr_data[2];
}
close (INBLASTP);

my %kegg_snp_data=();
open (INKEGGSNP,"</home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/g8p_snpEff_genes_variants_snp_impact_HIGH/user_ko_definition_snp.txt");
foreach my $kegg_snp_data(<INKEGGSNP>){
	chomp $kegg_snp_data;
	my @kegg_snp_data=split (/\t/,$kegg_snp_data);
	if ($kegg_snp_data[1]){
		$kegg_snp_data{$kegg_snp_data[0]}=$kegg_snp_data[1];
	}else {
		$kegg_snp_data{$kegg_snp_data[0]}="NA";
	}
}
close (INKEGGSNP);

my %kegg_indel_data=();
open (INKEGGINDEL,"</home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/g8p_snpEff_genes_variants_indel_impact_HIGH/user_ko_definition_indel.txt");
foreach my $kegg_indel_data(<INKEGGINDEL>){
	chomp $kegg_indel_data;
	my @kegg_indel_data=split (/\t/,$kegg_indel_data);
	if ($kegg_indel_data[1]){
		$kegg_indel_data{$kegg_indel_data[0]}=$kegg_indel_data[1];
	}else {
		$kegg_indel_data{$kegg_indel_data[0]}="NA";
	}
}
close (INKEGGINDEL);

open (OUTERROR,">/home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/tt/tt/error.txt");

my @files_snp_path=glob "/home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/g8p_snpEff_genes_variants_snp_impact_HIGH/result/*.txt";
foreach my $file_snp_path(@files_snp_path){
	chomp $file_snp_path;
	(my $file_snp_name=$file_snp_path)=~s/.*\/(.*)/$1/;
	open (INFILESNP,"<${file_snp_path}");
	open (OUTSNP,">/home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/tt/tt/snp/snp_${file_snp_name}");
	print OUTSNP "Gene_ID\tko_number\tblastp_identity_ratio\tDanio_rerio_subject_gene\n";
	foreach my $file_snp_data(<INFILESNP>){
		chomp $file_snp_data;
		my @file_snp_data=split (/\t/,$file_snp_data);
		if (exists $kegg_snp_data{$file_snp_data[0]}){
			if (exists $gc_blastp_dr_data{$file_snp_data[0]}){
				print OUTSNP "$file_snp_data[0]\t$kegg_snp_data{$file_snp_data[0]}\t$gc_blastp_dr_data{$file_snp_data[0]}{'identity_ratio'}\t$gc_blastp_dr_data{$file_snp_data[0]}{'subject'}\n";
			}else {
				print OUTSNP "$file_snp_data[0]\t$kegg_snp_data{$file_snp_data[0]}\tNA\tNA\n";
			}
		}else {
			print OUTERROR "snp\t$file_snp_name\t$file_snp_data[0]\tnot exists kegg data\n";
		}
	}
}
close (INFILESNP);
close (OUTSNP);

my @files_indel_path=glob "/home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/g8p_snpEff_genes_variants_indel_impact_HIGH/result/*.txt";
foreach my $file_indel_path(@files_indel_path){
	chomp $file_indel_path;
	(my $file_indel_name=$file_indel_path)=~s/.*\/(.*)/$1/;
	open (INFILEINDEL,"<${file_indel_path}");
	open (OUTINDEL,">/home/yinglu/grasscarp_reseq_8populations/snp_indel/statastic/tt/tt/indel/indel_${file_indel_name}");
	print OUTINDEL "Gene_ID\tko_number\tblastp_identity_ratio\tDanio_rerio_subject_gene\n";
	foreach my $file_indel_data(<INFILEINDEL>){
		chomp $file_indel_data;
		my @file_indel_data=split (/\t/,$file_indel_data);
		if (exists $kegg_indel_data{$file_indel_data[0]}){
			if (exists $gc_blastp_dr_data{$file_indel_data[0]}){
				print OUTINDEL "$file_indel_data[0]\t$kegg_indel_data{$file_indel_data[0]}\t$gc_blastp_dr_data{$file_indel_data[0]}{'identity_ratio'}\t$gc_blastp_dr_data{$file_indel_data[0]}{'subject'}\n";
			}else {
				print OUTINDEL "$file_indel_data[0]\t$kegg_indel_data{$file_indel_data[0]}\tNA\tNA\n";
			}
		}else {
			print OUTERROR "indel\t$file_indel_name\t$file_indel_data[0]\tnot exists kegg data\n";
		}
	}
}
close (INFILEINDEL);
close (OUTINDEL);
close (OUTERROR);

