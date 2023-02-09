#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;
use Data::Dumper;
use Statistics::Descriptive;
use Statistics::Distributions;
use Statistics::Robust::Scale qw(MAD);
use Text::NSP::Measures::2D::Fisher::twotailed;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
#my @a = qw/1 2 3/;
#my @b = qw/a b c/;
#
#my @c = glob "{@{[join ',', @a]}}_{@{[join ',', @b]}}";
#map {print "$_\n"} @c;
#
#my @d = (0, 1, map {$_ * 5 - 1, $_ * 5 + 1} 1..6);
#map {print "$_\n"} @d;
#
#my %hash = ();
#my @a = qw/1 1 2 2 3 3/;
#@a = grep {++$hash{$_} < 2} @a;
#print Dumper (\@a);
#print join ("\t", grep {++$hash{$_} < 2} @a);
#
#my $a = "abc1";
#my $b = "abc1";
#print "$a\n";
#print "1\n" if ($a =~ /^$b(?!\D)/);
#print "1\n" if ($a =~ /^$b(?![0-9])/);
#########################################################################################################
#my @pathes = glob "'D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - /*Temprature_c*gene_summary.txt'";
#open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - _gene_union_Temprature_c.txt") or die "$!";
#
##my @pathes = glob "'D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - /*Temprature_1_10*gene_summary.txt'";
##open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - _gene_union_Temprature_1_10.txt") or die "$!";
#
##my @pathes = glob "'D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - /*gene_summary.txt'";
##open (OUT, ">D:/research work/Takifugu/RNAseq/03.statistics/02.WGCNA/Fugu_4/Liver_updown_TA040716vsTU040716_union - _gene_union_Temprature_c_Temprature_1_10.txt") or die "$!";
#
#my (%gene_name) = ();
#foreach my $path (@pathes) {
#	open (IN, "<$path") or die "$!";
#	while (<IN>) {
#		chomp (my $data = $_);
#		next if ($data =~ /^Genename.*/);
#		my @data = split (/\t/, $data);
#		$gene_name{$data[0]} = 1;
#	}
#	close (IN);
#}
#
#print OUT "Genename\n";
#map {print OUT "$_\n";} sort {$a cmp $b} keys %gene_name;
#close (OUT);
#########################################################################################################
#open (INWGCNA, "<D:/research work/Takifugu/RNAseq/03.statistics/11.MEGENA/t/WGCNA_hub_gene/BrainLiver_updown_TA040716vsTA24_TU040716vsTU24_union - _gene_union_Temprature_c_Temprature_1_10.txt") or die "$!";
#open (INMEGENA, "<D:/research work/Takifugu/RNAseq/03.statistics/11.MEGENA/t/MEGENA_Hub_Gene/module_summary_BrainLiver_updown_TA040716vsTA24_TU040716vsTU24_union - .txt") or die "$!";
#open (OUTUNION, ">D:/research work/Takifugu/RNAseq/03.statistics/11.MEGENA/t/BrainLiver_updown_TA040716vsTA24_TU040716vsTU24_union - _wgcna_megena_gene_union.txt") or die "$!";
#open (OUTINTERSECTION, ">D:/research work/Takifugu/RNAseq/03.statistics/11.MEGENA/t/BrainLiver_updown_TA040716vsTA24_TU040716vsTU24_union - _wgcna_megena_gene_intersection.txt") or die "$!";
#
#my (%wgcna) = ();
#while (<INWGCNA>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^Genename.*/);
#	my @data = split (/\t/, $data);
#	$wgcna{$data[0]} = 1;
#}
#close (INWGCNA);
#
#my (%megena) = ();
#while (<INMEGENA>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^gene_name.*/);
#	next unless ($data);
#	my @data = split (/\t/, $data);
#	$megena{$data[0]} = 1;
#}
#close (INMEGENA);
#
#my (%gene) = ();
#foreach my $wgcna_gene_name (keys %wgcna) {
#	$gene{$wgcna_gene_name}++;
#}
#
#foreach my $megena_gene_name (keys %megena) {
#	$gene{$megena_gene_name}++;
#}
#
#foreach my $gene_name (sort {$a cmp $b} keys %gene) {
#	print OUTUNION "$gene_name\n";
#	print OUTINTERSECTION "$gene_name\n" if ($gene{$gene_name} == 2);
#}
#close (OUTUNION);
#close (OUTINTERSECTION);
#########################################################################################################
#open (IN, "<D:/input.txt") or die "$!";
#open (OUT, ">D:/output.txt") or die "$!";
#
#my (%gene) = ();
#while (<IN>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	$data[2] = "NA" unless ($data[2]);
#	if (exists $gene{$data[0]}) {
#		if ($gene{$data[0]} ne $data[2]) {
#			print STDERR "$data[0]\n";
#		}
#	}
#	$gene{$data[0]} = $data[2];
#}
#close (IN);
#
#while (<DATA>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\|/, $data);
#	my (@gene_name) = ();
#	foreach my $gene_id (@data) {
#		if (exists $gene{$gene_id}) {
#			push (@gene_name, $gene{$gene_id});
#		} else {
#			push (@gene_name, "NA");
#		}
#	}
#	print OUT join ("|", @gene_name), "\n";
#}
#close (DATA);
#close (OUT);
#####################################################################################################
#open (INVCF, "<D:/t_phased.vcf/t_phased.vcf") or die "$!";
#open (INPOP, "<D:/t_phased.vcf/pop.txt") or die "$!";
#open (OUT, ">D:/t_phased.vcf/t.txt") or die "$!";
#
#my $region = "1:118556-128730";
#$region =~ /(\w+):(\w+)-(\w+)/;
##$ARGV[3] =~ /(\w+):(\w+)-(\w+)/;
#my ($chr, $start, $end) = ($1, $2, $3);
#
#my ($i, @header, %vcf) = ();
#while (<INVCF>) {
#	chomp (my $data = $_);
#	if ($data =~ /^#.*/) {
#		@header = split (/\t/, $data) if ($data =~ /^#[^#].*/);
#		next;
#	}
#	my @data = split (/\t/, $data);
#	if ($data[0] eq $chr) {
#		if ($data[1] >= $start and $data[1] <= $end) {
#			$i++;
#			map {push (@{$vcf{$i}}, $_)} @data;
#		}
#	}
#}
#close (INVCF);
#
#my (%haplotype) = ();
#foreach my $g (sort {$a <=> $b} keys %vcf) {
#	my @vcf = @{$vcf{$g}};
#	for (my $h = 9; $h <= $#vcf; $h++) {
#		my $first = substr ($vcf[$h], 0, 1);
#		my $second = substr ($vcf[$h], 2, 1);
#		my ($first_allele, $second_allele) = ();
#		$first_allele = $vcf[3] if ($first == 0);
#		$first_allele = $vcf[4] if ($first == 1);
#		$second_allele = $vcf[3] if ($second == 0);
#		$second_allele = $vcf[4] if ($second == 1);
#		$haplotype{$header[$h]}{"1"} .= $first_allele;
#		$haplotype{$header[$h]}{"2"} .= $second_allele;
#	}
#}
#
#while (<INPOP>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	if (exists $haplotype{$data[0]}) {
#		print OUT ">$data[0].1\t", join ("\t", @data[1..$#data]), "\n";
#		print OUT $haplotype{$data[0]}{"1"}, "\n";
#		print OUT ">$data[0].2\t", join ("\t", @data[1..$#data]), "\n";
#		print OUT $haplotype{$data[0]}{"2"}, "\n";
#	} else {
#		print STDERR "$data[0]\n";
#	}
#}
#close (INPOP);
#close (OUT);
#####################################################################################################
#my %hash = ("a" => "1", "b" => "1", "c" => "2");
#print Dumper (\%hash);
#
#my %ha = ();
#my @b = grep{++$ha{$_}<2} values %hash;
#print @b;
#####################################################################################################
#my %d = ();
#chomp(my @text = <DATA>);
#my $keys = $text[0];
#my $values = $text[1];
#my $expression = '@d{qw('.$keys.')}'.' = '.'qw('.$values.')';
#print "$expression\n";
#eval($expression);
#print Dumper (\%d);
#
#my $x = "I like dogs.";
#my $y = $x =~ s/dogs/cats/r;
#print "$x $y\n"; # prints "I like dogs. I like cats."

#my $a = "weishang";
#my $b = substr($a, 3, 3, "111");
#
#print $a, "\n";
#print $b, "\n";
#####################################################################################################
#open (INCLS, "<D:/Cn_all_samples_3.clst") or die "$!";
#open (OUT, ">D:/t.txt") or die "$!";
#
#my (@pop, %cls) = ();
#while (<INCLS>) {
#	chomp (my $data = $_);
#	my @cls = split (/\t/, $data);
#	push (@pop, $cls[2]) unless ($cls{$cls[2]});
#	push (@{$cls{$cls[2]}}, $cls[0]);
#}
#close (INCLS);
#
#foreach my $pop (@pop) {
#	foreach my $chr (1..24) {
#		my $str = join (",", @{$cls{$pop}});
#		print OUT "nohup smc++ vcf2smc Cn_all_samples_filtered_rmgap_snp_hard_sorted.vcf.gz data/${pop}_LG${chr}.smc.gz LG${chr} ${pop}:$str > log/smcpp_vcf2smc_${pop}_LG${chr}.log 2>&1 &\n";
#	}
#	print OUT "\n";
#}
#
#foreach my $pop1 (@pop) {
#	foreach my $pop2 (@pop) {
#		foreach my $chr (1..24) {
#			next if ($pop1 eq $pop2);
#			my $str1 = join (",", @{$cls{$pop1}});
#			my $str2 = join (",", @{$cls{$pop2}});
#			print OUT "nohup smc++ vcf2smc Cn_all_samples_filtered_rmgap_snp_hard_sorted.vcf.gz data/${pop1}_${pop2}_LG${chr}.smc.gz LG${chr} ${pop1}:$str1 ${pop2}:$str2 > log/smcpp_vcf2smc_${pop1}_${pop2}_LG${chr}.log 2>&1 &\n";
#		}
#		print OUT "\n";
#	}
#}
#
#print OUT "mkdir";
#for (my $i = 0; $i <= $#pop; $i++) {
#	for (my $g = $i + 1; $g <= $#pop; $g++) {
#		my $pop1 = $pop[$i];
#		my $pop2 = $pop[$g];
#		my $str1 = join (",", @{$cls{$pop1}});
#		my $str2 = join (",", @{$cls{$pop2}});
#		print OUT " split/${pop1}_${pop2}";
#	}
#}
#print OUT "\n\n";
#
#for (my $i = 0; $i <= $#pop; $i++) {
#	for (my $g = $i + 1; $g <= $#pop; $g++) {
#		my $pop1 = $pop[$i];
#		my $pop2 = $pop[$g];
#		my $str1 = join (",", @{$cls{$pop1}});
#		my $str2 = join (",", @{$cls{$pop2}});
#		print OUT "nohup smc++ split -o split/${pop1}_${pop2} estimate/${pop1}/model.final.json estimate/${pop2}/model.final.json data/${pop1}_LG*.smc.gz data/${pop2}_LG*.smc.gz data/${pop1}_${pop2}_LG*.smc.gz data/${pop2}_${pop1}_LG*.smc.gz > log/smcpp_split_${pop1}_${pop2}.log 2>&1 &\n";
#	}
#}
#close (OUT);
#####################################################################################################
#my $a = "CATATCG";
#$a =~ tr/ATCG/TAGC/;
#print "$a\n";
#####################################################################################################
#open (INANNOTATION, "<D:/research work/Grass_carp//methy_gene_table/gene_name_list.txt") or die "$!";
#open (INENRICHMENT, "<D:/research work/Grass_carp//methy_gene_table/methy_gene_list_v2.txt") or die "$!";
#open (OUT, ">D:/research work/Grass_carp//methy_gene_table/t.txt") or die "$!";
#
#my %gene_annotation = ();
#while (<INANNOTATION>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	$gene_annotation{$data[0]} = $data[2];
#}
#close (INANNOTATION);
#
#my %gene_enrichment = ();
#while (<INENRICHMENT>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	my @gene_id = split (/\|/, $data[8]);
#	foreach my $gene_id (@gene_id) {
##		$gene_enrichment{$data[0]}{$gene_id}{"GO_term"}{$data[1]} = 1;
##		$gene_enrichment{$data[0]}{$gene_id}{"GO_id"}{$data[3]} = 1;
#		$gene_enrichment{$data[0]}{$gene_id}{$data[1]} = $data[3];
#	}
#}
#close (INENRICHMENT);
#
#foreach my $cluster (sort {$a cmp $b} keys %gene_enrichment) {
#	foreach my $id (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}}) {
##		my @go_term = sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}{"GO_term"}};
##		my @go_id = sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}{"GO_id"}};
#		my @temp = ();
#		foreach my $goterm (sort {$a cmp $b} keys %{$gene_enrichment{$cluster}{$id}}) {
#			my $temp = "$goterm ($gene_enrichment{$cluster}{$id}{$goterm})";
#			push (@temp, $temp);
#		}
#		if ($gene_annotation{$id}) {
##			print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @go_term), "\t", join (" | ", @go_id), "\n";
#			print OUT "$cluster\t$id\t$gene_annotation{$id}\t", join (" | ", @temp), "\n";
#		} else {
##			print OUT "$cluster\t$id\tNA\t", join ("\t", @{$gene_enrichment{$cluster}{$id}{"GO"}}), "\t", join (" | ", @go_id), "\n";
#			print OUT "$cluster\t$id\tNA\t", join (" | ", @temp), "\n";
#		}
#	}
#}
#close (OUT);
#####################################################################################################
#open (INMATRIX, "<D:/research work/Grass_carp/Resequence/IN_vs_TJ_reseq_50kb_2kb_top005.matrix") or die "$!";
#
#my %region = ();
#while (<INMATRIX>) {
#	chomp (my $data = $_);
#	next if ($data =~ /^#.*/);
#	my @data = split (/\t/, $data);
#	$region{$data[0]}{$data[1]} = $data[2];
#}
#close (INMATRIX);
#
#my $total_region_length_sum = ();
#foreach my $chr (sort {$a cmp $b} keys %region) {
#	my @start = sort {$a <=> $b} keys %{$region{$chr}};
#	my (@region_start, @region_t, @region_end) = ();
#	unshift (@start, -3000);
#	for (my $i = 1; $i <= $#start; $i++) {
#		my $step = $start[$i] - $start[$i - 1];
#		if ($step != 2000) {
#			push (@region_start, $start[$i]);
#			push (@region_t, $start[$i - 1]);
#		}
#	}
#	shift @region_t;
#	push (@region_t, $start[$#start]);
#	map {push (@region_end, $region{$chr}{$_})} @region_t;
#	my $region_length_sum = ();
#	
#	for (my $p = 0; $p <= $#region_start; $p++) {
#		my $region_length = $region_end[$p] - $region_start[$p];
#		$region_length_sum += $region_length;
#		$total_region_length_sum += $region_length;
#	}
#	print "$chr\t$region_length_sum\n";
#}
#print "$total_region_length_sum\n";
#####################################################################################################
#my $a = 0;
#my $b = 1;
#if ($a eq $b) {
#	print "eq\n";
#} else {
#	print "ne\n";
#}

#my $a = "atcgATCGN";
#print $a, "\n";
#$a =~ tr/atcgATCG/tagcTAGC/;
#print $a, "\n";
#####################################################################################################
#my $zscore = 0.141461368;
#my $pvalue = Statistics::Distributions::uprob($zscore);
#print "$zscore\t$pvalue\n";

#####################################################################################################
##          word2   ~word2
##  word1    n11      n12 | n1p
## ~word1    n21      n22 | n2p
##           --------------
##           np1      np2   npp
#my ($n11, $n1p, $np1, $npp) = (90, 100, 140, 200);
#my $pValue = Text::NSP::Measures::2D::Fisher::twotailed::calculateStatistic(n11 => $n11, n1p => $n1p, np1 => $np1, npp => $npp);
#my $statisticName = Text::NSP::Measures::2D::Fisher::twotailed::getStatisticName;
##$statisticName = join "",(split(/\s+/,$statisticName));
#print "$n11\t$n1p\t$np1\t$npp\n$pValue\t$statisticName\n";
#####################################################################################################
#my @d = qw/0 1 2 3 4 5/;
#my @order_d = ();
#for (qw/1 3 2/){
#	push @order_d,$d[2*$_-2],$d[2*$_-1]; 
#}
#map {print "$_\n"} @order_d;
#
#####################################################################################################
#my $str = "abcdefghijk";
#my $pattern = ();
#
#if ($str =~ /($pattern)/) {
#	print "1\n";
#} else {
#	print "2\n";
#}
#####################################################################################################
#sub parse_pattern {
#  $_ = shift;
#  s/\s+//g;
#  @_ = split('\+');
#  print "@_\n";
#  my $n_lambda = 0;
#  my @stack;
#  for (@_) {
#	my ($x1, $x2) = (1, $_);
#	$x1 = $1, $x2 = $2 if (/(\d+)\*(\d+)/);
#	push(@stack, $x2) for (0 .. $x1-1);
#	$n_lambda += $x1;
#  }
#  my @ret;
#  for my $i (0 .. $#stack) {
#	push(@ret, $i) for (0 .. $stack[$i]-1);
#  }
#  return ($n_lambda, @ret);
#}
#
#my $pattern = "4+25*2+4+6";
#my ($n_lambda, @pat) = &parse_pattern($pattern);
##print "$n_lambda\n";
##print "@pat\n";
#####################################################################################################
#my $RS = "RS	0	0.000000	1.000000	99.111799	0.007408	0.000486";
#$RS =~ /^RS\s(\d+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)/;
##print "$1\n";
##print "$2\n";
##print "$3\n";
##print "$4\n";
##print "$5\n";
##print "$6\n";
#
#
#my $d = ();
#@{$d->{D}[$1]} = ($2, $3, $4, $5, $6);
#
##print Dumper (\$d);
#print "@{@{%{$d}{'D'}}[0]}";
#####################################################################################################
my @a = qw/1 2 3 4 5 6 7/;
my @b = qw/2 4 6/;


#print join ("_", map {$a[$_]} @b);

splice(@a, 2, 0, @b);
print @a, "\n";
print "weishang\n";

my $a = <STDIN>;
print $a, "\n";



























#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;