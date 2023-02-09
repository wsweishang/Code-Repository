#!/usr/bin/perl

use strict;
use warnings;

open (INTXT, "<D:/research work/LargeYellowCroaker/LargeYellowCroaker_cluster_info.txt") or die "$!";

my %txt_data = ();
while (<INTXT>) {
	chomp (my $txt_data = $_);
	next if ($txt_data =~ /^#.*/);
	my @txt_data = split (/\t/, $txt_data);
	push (@{$txt_data{"subspecies"}{$txt_data[2]}}, $txt_data[1]);
	$txt_data{$txt_data[1]}{"subspecies"} = "$txt_data[2]";
	$txt_data{$txt_data[1]}{"fastq1"} = "$txt_data[3]";
	$txt_data{$txt_data[1]}{"fastq2"} = "$txt_data[4]";
}
close (INTXT);

foreach my $subspecies (keys %{$txt_data{"subspecies"}}) {
	open (OUT, ">D:/research work/LargeYellowCroaker/protocol/gatk/Record_of_GATK_LargeYellowCroaker_${subspecies}.sh") or die "$!";
	print OUT "#/home/yinglu/RAD/LargeYellowCroaker/gatk\n";
	print OUT "#$subspecies\n";
	print OUT "#1 BWA INDEX\n";
	print OUT "nohup bwa index -a is Larimichthys_crocea_chromosome.fa > bwa_index.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#2 BWA MEM\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup bwa mem -t 4 -M Larimichthys_crocea_chromosome.fa ../$txt_data{$sample}{'fastq1'} ../$txt_data{$sample}{'fastq1'} -o $subspecies/${sample}.sam > $subspecies/bwa_mem_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#3 Sam to sortedBam\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup gatk SortSam -I $subspecies/${sample}.sam -O $subspecies/${sample}_sorted.bam -SO coordinate > $subspecies/gatk_sortsam_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#4 deduplication\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup gatk MarkDuplicates -I $subspecies/${sample}_sorted.bam -O $subspecies/${sample}_sorted_deduplicated.bam -M $subspecies/${sample}_sorted_deduplicated.metrics > $subspecies/gatk_markduplicates_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#5 add\@RG\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup gatk AddOrReplaceReadGroups -I $subspecies/${sample}_sorted_deduplicated.bam -O $subspecies/${sample}_sorted_deduplicated_addRGhead.bam -ID ${sample} -LB ${sample} -PL ILLUMINA -PU ${sample} -SM ${sample} > $subspecies/gatk_addorreplacereadgroups_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#6 Samtools|GATK建索引\n";
	print OUT "nohup gatk CreateSequenceDictionary -R Larimichthys_crocea_chromosome.fa -O Larimichthys_crocea_chromosome.dict > gatk_createsequencedictionary.log 2>&1 &\n";
	print OUT "\n";
	print OUT "nohup samtools faidx Larimichthys_crocea_chromosome.fa > samtools_faidx.log 2>&1 &\n";
	print OUT "\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup samtools index $subspecies/${sample}_sorted_deduplicated_addRGhead.bam > $subspecies/samtools_index_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#7 call snp\n";
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "nohup gatk HaplotypeCaller --genotyping-mode DISCOVERY -ERC GVCF --pcr-indel-model CONSERVATIVE -R Larimichthys_crocea_chromosome.fa -I $subspecies/${sample}_sorted_deduplicated_addRGhead.bam -O $subspecies/${sample}_sorted_deduplicated_addRGhead.g.vcf > $subspecies/gatk_haplotypecaller_${sample}.log 2>&1 &\n";
	}
	print OUT "\n";
	print OUT "\n";
	print OUT "#8 combine gvcf to vcf\n";
	print OUT "nohup gatk CombineGVCFs -R Larimichthys_crocea_chromosome.fa -O $subspecies/vcf/${subspecies}_combined.vcf ";
	
	foreach my $sample (@{$txt_data{"subspecies"}{$subspecies}}) {
		print OUT "-V $subspecies/${sample}_sorted_deduplicated_addRGhead.g.vcf ";
		
	}
	print OUT "> $subspecies/vcf/gatk_combinegvcfs_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#9 鉴定变异位点\n";
	print OUT "nohup gatk GenotypeGVCFs -R Larimichthys_crocea_chromosome.fa -V $subspecies/vcf/${subspecies}_combined.vcf -O $subspecies/vcf/${subspecies}_combined_raw.vcf > $subspecies/vcf/gatk_genotypegvcfs_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#10 过滤snp\n";
	print OUT "nohup gatk VariantFiltration --filter-name FilterAN --filter-expression \"AN < 4.0\" --filter-name FilterFS --filter-expression \"FS > 10.0\" --filter-name FilterDP --filter-expression \"DP < 10.0\" -R Larimichthys_crocea_chromosome.fa -V $subspecies/vcf/${subspecies}_combined_raw.vcf -O $subspecies/vcf/${subspecies}_combined_filtered.vcf > $subspecies/vcf/gatk_variantfiltration_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "\n";
	print OUT "#11 分离snp和indel\n";
	print OUT "nohup gatk SelectVariants -V $subspecies/vcf/${subspecies}_combined_filtered.vcf -O $subspecies/vcf/${subspecies}_combined_filtered_hard.vcf --exclude-filtered true > $subspecies/vcf/gatk_selectvariants_${subspecies}.log 2>&1 &\n";
	print OUT "\n";
	print OUT "nohup gatk SplitVcfs -I $subspecies/vcf/${subspecies}_combined_filtered_hard.vcf --SNP_OUTPUT $subspecies/vcf/${subspecies}_combined_filtered_hard_snp.vcf --INDEL_OUTPUT $subspecies/vcf/${subspecies}_combined_filtered_hard_indel.vcf --STRICT false > $subspecies/vcf/gatk_splitvcfs_${subspecies}.log 2>&1 &\n";
}
close (OUT);

__DATA__
#No	Species	Cluster	Reads_1	Reads_2
1	YZ2	YZ	cro_001.1.fq	cro_001.2.fq
2	YZ3	YZ	cro_002.1.fq	cro_002.2.fq
3	YZ4	YZ	cro_003.1.fq	cro_003.2.fq
4	YZ5	YZ	cro_004.1.fq	cro_004.2.fq
5	YZ6	YZ	cro_005.1.fq	cro_005.2.fq
6	YZ10	YZ	cro_007.1.fq	cro_007.2.fq
7	YZ11	YZ	cro_008.1.fq	cro_008.2.fq
8	YZ12	YZ	cro_009.1.fq	cro_009.2.fq
9	YZ13	YZ	cro_010.1.fq	cro_010.2.fq
10	YZ14	YZ	cro_011.1.fq	cro_011.2.fq
11	YZ15	YZ	cro_012.1.fq	cro_012.2.fq
12	DH2	DH	cro_014.1.fq	cro_014.2.fq
13	DH3	DH	cro_015.1.fq	cro_015.2.fq
14	DH4	DH	cro_016.1.fq	cro_016.2.fq
15	DH5	DH	cro_017.1.fq	cro_017.2.fq
16	DH8	DH	cro_020.1.fq	cro_020.2.fq
17	DH9	DH	cro_021.1.fq	cro_021.2.fq
18	DH10	DH	cro_022.1.fq	cro_022.2.fq
19	DH11	DH	cro_023.1.fq	cro_023.2.fq
20	DH12	DH	cro_024.1.fq	cro_024.2.fq
21	DH13	DH	cro_025.1.fq	cro_025.2.fq
22	DH14	DH	cro_026.1.fq	cro_026.2.fq
23	DH15	DH	cro_027.1.fq	cro_027.2.fq
24	ZJ1	ZJ	cro_028.1.fq	cro_028.2.fq
25	ZJ2	ZJ	cro_029.1.fq	cro_029.2.fq
26	ZJ3	ZJ	cro_030.1.fq	cro_030.2.fq
27	ZJ6	ZJ	cro_031.1.fq	cro_031.2.fq
28	ZJ9	ZJ	cro_034.1.fq	cro_034.2.fq
29	ZJ10	ZJ	cro_035.1.fq	cro_035.2.fq
30	ZJ16	ZJ	cro_039.1.fq	cro_039.2.fq