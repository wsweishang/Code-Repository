#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<D:/research work/Grass carp/protocol/GATK/SLAF_cluster_info.txt") or die "$!";
open (OUT, ">D:/research work/Grass carp/protocol/GATK/Record_of_SLAF_GATK.sh") or die "$!";

my %txt_data = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^#.*/);
	my @txt_data = split (/\t/, $txt_data);
	$txt_data{$txt_data[0]}{"ID"} = "$txt_data[0]_$txt_data[1]";
	$txt_data{$txt_data[0]}{"fq1"} = $txt_data[4];
	$txt_data{$txt_data[0]}{"fq2"} = $txt_data[5];
}
close (INTXT);

my $current_time = localtime();
print OUT "#$current_time\n";
print OUT "#/home/yinglu/grasscarp_reseq_8populations/SLAF/Rawdata/Cleandata/gatk\n";
print OUT "#1 Trimmomatic\n";
print OUT "#百迈客下来的数据是切过接头的，但是没有进一步清洗\n";
foreach my $number (sort keys %txt_data) {
	print OUT "nohup trimmomatic PE -trimlog ../Trim_$txt_data{$number}{'ID'}.trimlog ../../$txt_data{$number}{'fq1'} ../../$txt_data{$number}{'fq2'} ../$txt_data{$number}{'ID'}_forward_paired.fq ../$txt_data{$number}{'ID'}_forward_unpaired.fq ../$txt_data{$number}{'ID'}_reverse_paired.fq ../$txt_data{$number}{'ID'}_reverse_unpaired.fq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:70 HEADCROP:15 > ../log/trimmomatic_$txt_data{$number}{'ID'}.log 2>&1 &\n";
}
print OUT "\n\n";
print OUT "#2 BWA INDEX\n";
print OUT "nohup bwa index -a is Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta > log/bwa_index.log 2>&1 &\n";
print OUT "\n\n";
print OUT "#3 BWA MEM\n";
foreach my $number (sort keys %txt_data) {
	print OUT "nohup bwa mem -t 4 -M -R \"\@RG\\tID:C_idella_$txt_data{$number}{'ID'}\\tLB:C_idella_$txt_data{$number}{'ID'}\\tPL:ILLUMINA\\tPU:C_idella_$txt_data{$number}{'ID'}\\tSM:C_idella_$txt_data{$number}{'ID'}\" Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta ../$txt_data{$number}{'ID'}_forward_paired.fq ../$txt_data{$number}{'ID'}_reverse_paired.fq -o $txt_data{$number}{'ID'}.sam > log/bwa_mem_$txt_data{$number}{'ID'}.log 2>&1 &\n";
}
print OUT "\n\n";
print OUT "#4 Sam to sortedBam\n";
foreach my $number (sort keys %txt_data) {
	print OUT "nohup gatk SortSam -I $txt_data{$number}{'ID'}.sam -O $txt_data{$number}{'ID'}_sorted.bam -SO coordinate > log/gatk_sortsam_$txt_data{$number}{'ID'}.log 2>&1 &\n";
}
print OUT "\n\n";
print OUT "#5 Samtools|GATK建索引\n";
print OUT "nohup gatk CreateSequenceDictionary -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -O Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.dict > log/gatk_createsequencedictionary.log 2>&1 &\n";
print OUT "\n";
print OUT "nohup samtools faidx Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta > log/samtools_faidx.log 2>&1 &\n";
print OUT "\n";
foreach my $number (sort keys %txt_data) {
	print OUT "nohup samtools index $txt_data{$number}{'ID'}_sorted.bam > log/samtools_index_$txt_data{$number}{'ID'}.log 2>&1 &\n";
}
print OUT "\n\n";
print OUT "#6 call snp\n";
foreach my $number (sort keys %txt_data) {
	print OUT "nohup gatk HaplotypeCaller --genotyping-mode DISCOVERY -ERC GVCF --pcr-indel-model CONSERVATIVE -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -I $txt_data{$number}{'ID'}_sorted.bam -O $txt_data{$number}{'ID'}_sorted.g.vcf > log/gatk_haplotypecaller_$txt_data{$number}{'ID'}.log 2>&1 &\n";
}
print OUT "\n\n";
print OUT "#7 combine gvcf to vcf\n";
print OUT "nohup gatk CombineGVCFs -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta ";
foreach my $number (sort keys %txt_data) {
	print OUT "-V $txt_data{$number}{'ID'}_sorted.g.vcf ";
}
print OUT "-O vcf/SLAF_combined.vcf > vcf/log/gatk_combinegvcfs_SLAF.log 2>&1 &\n";
print OUT "\n\n";
print OUT "#8 鉴定变异位点\n";
print OUT "nohup gatk GenotypeGVCFs -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -V vcf/SLAF_combined.vcf -O vcf/SLAF_combined_raw.vcf > vcf/log/gatk_genotypegvcfs_SLAF.log 2>&1 &\n";
print OUT "\n\n";
print OUT "#9 过滤snp\n";
print OUT "nohup gatk VariantFiltration --filter-name FilterAF --filter-expression \"AF < 0.05\" --filter-name FilterAN --filter-expression \"AN < 20.0\" --filter-name FilterFS --filter-expression \"FS > 60.0\" --filter-name FilterDP --filter-expression \"DP < 20.0\" -R Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta -V vcf/SLAF_combined_raw.vcf -O vcf/SLAF_combined_filtered.vcf > vcf/log/gatk_variantfiltration_SLAF.log 2>&1 &\n";
print OUT "\n\n";
print OUT "#10 分离snp和indel\n";
print OUT "nohup gatk SelectVariants --exclude-filtered true -V vcf/SLAF_combined_filtered.vcf -O vcf/SLAF_combined_filtered_hard.vcf > vcf/log/gatk_selectvariants_SLAF.log 2>&1 &\n";
print OUT "\n";
print OUT "nohup gatk SplitVcfs -I vcf/SLAF_combined_filtered_hard.vcf --SNP_OUTPUT vcf/SLAF_combined_filtered_hard_snp.vcf --INDEL_OUTPUT vcf/SLAF_combined_filtered_hard_indel.vcf --STRICT false > vcf/log/gatk_splitvcfs_SLAF.log 2>&1 &\n";

close (OUT);



