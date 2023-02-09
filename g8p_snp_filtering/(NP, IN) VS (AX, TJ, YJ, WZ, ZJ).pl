#!/usr/bin/perl

use strict;
use warnings;

#(NP, IN) VS (AX, TJ, YJ, WZ, ZJ)

sub SUM{
	my @all=@_;
	$all[12] += $all[11];
	$all[13] += $all[12];
	$all[14] += $all[13];
	$all[16] += $all[14];
	$all[17] += $all[16];
	$all[18] += $all[17];
	return $all[18];
}

open (OUT,">G:/(NP, IN) VS (AX, TJ, YJ, WZ, ZJ).txt");
my %compared_data=();
my @population_compared_filenames=qw/AX_S4_snp_snpEff_genes.txt TJ_S3_snp_snpEff_genes.txt YJ_S2_snp_snpEff_genes.txt WZ_S1_snp_snpEff_genes.txt ZQ_S4_snp_snpEff_genes.txt/;
foreach my $population_compared_filename(@population_compared_filenames){
	open (INCOMPARED,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/${population_compared_filename}");
	my @population_compared_file=<INCOMPARED>;
	foreach my $population_compared_data(@population_compared_file){
		chomp $population_compared_data;
		next if ($population_compared_data=~/^#.*/);
		my @population_compared_content=split(/\t/,$population_compared_data);
		$compared_data{$population_compared_content[1]}{$population_compared_filename}=1;
	}	
}

my @population_compare_filenames=qw/NP_S1_snp_snpEff_genes.txt IN_S2_snp_snpEff_genes.txt/;
foreach my $population_compare_filename(@population_compare_filenames){
	open (INCOMPARE,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/${population_compare_filename}");
	my @population_compare_file=<INCOMPARE>;
	foreach my $population_compare_data(@population_compare_file){
		chomp $population_compare_data;
		next if ($population_compare_data=~/^#.*/);
		my @population_compare_content=split(/\t/,$population_compare_data);
		unless (exists $compared_data{$population_compare_content[1]}){
			my $result=&SUM(@population_compare_content);
			unless ($result==0){
				say OUT $population_compare_data;
			}
		}
	}
}
close (OUT);



#(NP, IN) VS (AX, TJ, YJ, WZ, ZJ)国内VS国外
#(NP, IN,VN, AX, TJ) VS (YJ, WZ, ZJ)
#(YJ, AX, WZ) VS (VN, TJ, ZJ)

#open (INNP,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/NP_S1_snp_snpEff_genes.txt");
#open (ININ,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/IN_S2_snp_snpEff_genes.txt");
#open (INAX,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/AX_S4_snp_snpEff_genes.txt");
#open (INTJ,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/TJ_S3_snp_snpEff_genes.txt");
#open (INYJ,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/YJ_S2_snp_snpEff_genes.txt");
#open (INWZ,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/WZ_S1_snp_snpEff_genes.txt");
#open (INZJ,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/ZQ_S4_snp_snpEff_genes.txt");
#open (OUT,">G:/1.txt");
#my @innp=<INNP>;
#my @inin=<ININ>;
#my @inax=<INAX>;
#my @intj=<INTJ>;
#my @inyj=<INYJ>;
#my @inwz=<INWZ>;
#my @inzj=<INZJ>;
#
#my %np=();
#foreach my $innp(@innp){
# 	chomp $innp;
# 	next if ($innp=~/^#.*/);
# 	my @np=split(/\t/,$innp);
# 	$np{$np[1]}=$innp;
#}
#my %in=();
#foreach my $inin(@inin){
#	chomp $inin;
#	next if ($inin=~/^#.*/);
#	my @in=split(/\t/,$inin);
#	$in{$in[1]}="1";
#}
#my %axtjyjwzzj=();
#foreach my $inax(@inax){
#	chomp $inax;
#	next if ($inax=~/^#.*/);
#	my @ax=split(/\t/,$inax);
#	$axtjyjwzzj{$ax[1]}="1";
#}
#foreach my $intj(@intj){
#	chomp $intj;
#	next if ($intj=~/^#.*/);
#	my @tj=split(/\t/,$intj);
#	$axtjyjwzzj{$tj[1]}="1";
#}
#foreach my $inyj(@inyj){
#	chomp $inyj;
#	next if ($inyj=~/^#.*/);
#	my @yj=split(/\t/,$inyj);
#	$axtjyjwzzj{$yj[1]}="1";
#}
#foreach my $inwz(@inwz){
#	chomp $inwz;
#	next if ($inwz=~/^#.*/);
#	my @wz=split(/\t/,$inwz);
#	$axtjyjwzzj{$wz[1]}="1";
#}
#foreach my $inzj(@inzj){
#	chomp $inzj;
#	next if ($inzj=~/^#.*/);
#	my @zj=split(/\t/,$inzj);
#	$axtjyjwzzj{$zj[1]}="1";
#}
#sub SUM{
#	my @all=@_;
#	$all[12] += $all[11];
#	$all[13] += $all[12];
#	$all[14] += $all[13];
#	$all[16] += $all[14];
#	$all[17] += $all[16];
#	$all[18] += $all[17];
#	return $all[18];
#}
#foreach my $innp(@innp){
#	chomp $innp;
#	next if ($innp=~/^#.*/);
#	my @np=split (/\t/,$innp);
#	unless (exists $axtjyjwzzj{$np[1]}){
#		my $sum=&SUM(@np);
#		unless ($sum==0){
#			say OUT $np{$np[1]};
#		}
#	}
#}

##&USAGE;
#sub USAGE {
#	my $usage=<<"usage";
#MANUAL
#OPTIONS:
#	(NP, IN) VS (AX, TJ, YJ, WZ, ZJ)
#	-ARGV[0]
#	-ARGV[1]
#	将NP、IN、AX、TJ、YJ、WZ、ZJ放入一个文件夹中
#	···
#usage
#	print $usage;
#	exit;
#}