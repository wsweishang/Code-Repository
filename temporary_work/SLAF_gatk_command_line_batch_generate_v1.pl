#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<D:/research work/Grass carp/protocol/GATK/Record_of_SLAF_GATK/SLAF_cluster_info.txt") or die "$!";
open (INFQLIST, "<D:/research work/Grass carp/protocol/GATK/Record_of_SLAF_GATK/fq.txt") or die "$!";

my %txt_data = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^#.*/);
	my @txt_data = split (/\t/, $txt_data);
	my @number = &ADDZERO ($txt_data[0]);
	my @client = &ADDZERO ($txt_data[1]);
	$txt_data{$txt_data[3]}{$number[0]} = "$number[0]_$txt_data[3]_$client[0]";
}
close (INTXT);

my %fqlist_data = ();
while (<INFQLIST>) {
	chomp (my $fqlist_data = $_);
	next if ($fqlist_data =~ /^#.*/);
	$fqlist_data =~ m/.*-(\d+)-.*_(\d+)\..*/;
	my @number = &ADDZERO ($1);
	$fqlist_data{$number[0]}{"$2"} = $fqlist_data;
}
close (INFQLIST);

foreach my $subspecies (sort keys %txt_data) {
	open (OUT, ">D:/research work/Grass carp/protocol/GATK/Record_of_SLAF_GATK/Record_of_SLAF_GATK_$subspecies.sh") or die "$!";
	print OUT "#/home/yinglu/grasscarp_reseq_8populations/SLAF/Rawdata/Cleandata\n";
	print OUT "#$subspecies\n";
	print OUT "#1 Trimmomatic\n";
	print OUT "#百迈客下来的数据是切过接头的，但是没有进一步清洗\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$fqlist_data{$number}{1}\t$fqlist_data{$number}{2}\n";
		print OUT "nohup trimmomatic PE -trimlog Trim_$txt_data{$subspecies}{$number}.txt ../$fqlist_data{$number}{1} ../$fqlist_data{$number}{2} $txt_data{$subspecies}{$number}_forward_paired.fq $txt_data{$subspecies}{$number}_forward_unpaired.fq $txt_data{$subspecies}{$number}_reverse_paired.fq $txt_data{$subspecies}{$number}_reverse_unpaired.fq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:70 HEADCROP:15 > trimmomatic_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#2 BWA INDEX\n";
	print OUT "#nohup bwa index -a is Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta > bwa_index.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#3 BWA MEM\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup bwa mem -t 4 -M ../Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta ../../$txt_data{$subspecies}{$number}_forward_paired.fq ../../$txt_data{$subspecies}{$number}_reverse_paired.fq -o $txt_data{$subspecies}{$number}.sam > bwa_mem_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#4 Sam to sortedBam\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup gatk SortSam -I $txt_data{$subspecies}{$number}.sam -O $txt_data{$subspecies}{$number}_sorted.bam -SO coordinate > gatk_sortsam_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
		
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#5 deduplication\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup gatk MarkDuplicates -I $txt_data{$subspecies}{$number}_sorted.bam -O $txt_data{$subspecies}{$number}_sorted_deduplicated.bam -M $txt_data{$subspecies}{$number}_deduplicated.metrics > gatk_markduplicates_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
		
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#6 add\@RG\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup gatk AddOrReplaceReadGroups -I $txt_data{$subspecies}{$number}_sorted_deduplicated.bam -O $txt_data{$subspecies}{$number}_sorted_deduplicated_addRGhead.bam -ID C_idella_$txt_data{$subspecies}{$number} -LB C_idella_$txt_data{$subspecies}{$number} -PL ILLUMINA -PU C_idella_$txt_data{$subspecies}{$number} -SM C_idella_$txt_data{$subspecies}{$number} > gatk_addorreplacereadgroups_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
		
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#7 Samtools|GATK建索引\n";
	print OUT "#nohup gatk CreateSequenceDictionary -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -O Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.dict > gatk_createsequencedictionary.log 2>&1 &\n";
	print OUT "\n";
	print OUT "#nohup samtools faidx Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta > samtools_faidx.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup samtools index $txt_data{$subspecies}{$number}_sorted_deduplicated_addRGhead.bam > samtools_index_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
		
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#8 call snp\n";
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "#$txt_data{$subspecies}{$number}\n";
		print OUT "nohup gatk HaplotypeCaller --genotyping-mode DISCOVERY -ERC GVCF --pcr-indel-model CONSERVATIVE -R ../Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -I $txt_data{$subspecies}{$number}_sorted_deduplicated_addRGhead.bam -O $txt_data{$subspecies}{$number}_sorted_deduplicated_addRGhead.g.vcf > gatk_haplotypecaller_$txt_data{$subspecies}{$number}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#9 combine gvcf to vcf\n";
	print OUT "nohup gatk CombineGVCFs -R ../Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -O vcf/${subspecies}_combined.vcf ";
	
	foreach my $number (sort keys %{$txt_data{$subspecies}}) {
		print OUT "-V $txt_data{$subspecies}{$number}_sorted_deduplicated_addRGhead.g.vcf ";
		
	}
	print OUT "> gatk_combinegvcfs_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#10 鉴定变异位点\n";
	print OUT "nohup gatk GenotypeGVCFs -R ../../Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -O ${subspecies}_combined_raw.vcf -V ${subspecies}_combined.vcf > gatk_genotypegvcfs_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#11 过滤snp\n";
	print OUT "nohup gatk VariantFiltration --filter-name FilterAN --filter-expression \"AN < 4.0\" --filter-name FilterFS --filter-expression \"FS > 10.0\" --filter-name FilterDP --filter-expression \"DP < 10.0\" -R ../../Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -O ${subspecies}_combined_filtered.vcf -V ${subspecies}_combined_raw.vcf > gatk_variantfiltration_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#12 分离snp和indel\n";
	print OUT "nohup gatk SelectVariants -O ${subspecies}_combined_filtered_hard.vcf -V ${subspecies}_combined_filtered.vcf --exclude-filtered true > gatk_selectvariants_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "nohup gatk SplitVcfs -I ${subspecies}_combined_filtered_hard.vcf --SNP_OUTPUT ${subspecies}_combined_filtered_hard_snp.vcf --INDEL_OUTPUT ${subspecies}_combined_filtered_hard_indel.vcf --STRICT false > gatk_splitvcfs_${subspecies}.log 2>&1 &\n";
}
close (OUT);

sub ADDZERO {
	my $client = $_[0];
	$client =~ s/\D*(\d+)/$1/;
	my $client_length = length $client;
	if ($client_length == 1) {
		return ("0$client");
	} else {
		return ($client);
	}
}


