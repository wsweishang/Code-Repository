#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(gettimeofday);
my $start_time = gettimeofday;
#####################################################################################################
open (OUT, ">D:/research work/Coilia_nasus/3.statistics/02.population_size/1.smcpp/t.txt") or die "$!";

my (@pop, %cls) = ();
while (<DATA>) {
	chomp (my $data = $_);
	my @cls = split (/\t/, $data);
	push (@pop, $cls[2]) unless ($cls{$cls[2]});
	push (@{$cls{$cls[2]}}, $cls[0]);
}

foreach my $pop (@pop) {
	foreach my $chr (1..24) {
		my $str = join (",", @{$cls{$pop}});
		print OUT "nohup smc++ vcf2smc Cn_all_samples_filtered_rmgap_snp_hard_sorted.vcf.gz data/${pop}_LG${chr}.smc.gz LG${chr} ${pop}:$str > log/smcpp_vcf2smc_${pop}_LG${chr}.log 2>&1 &\n";
	}
	print OUT "\n";
}

foreach my $pop1 (@pop) {
	foreach my $pop2 (@pop) {
		foreach my $chr (1..24) {
			next if ($pop1 eq $pop2);
			my $str1 = join (",", @{$cls{$pop1}});
			my $str2 = join (",", @{$cls{$pop2}});
			print OUT "nohup smc++ vcf2smc Cn_all_samples_filtered_rmgap_snp_hard_sorted.vcf.gz data/${pop1}_${pop2}_LG${chr}.smc.gz LG${chr} ${pop1}:$str1 ${pop2}:$str2 > log/smcpp_vcf2smc_${pop1}_${pop2}_LG${chr}.log 2>&1 &\n";
		}
		print OUT "\n";
	}
}

print OUT "mkdir";
for (my $i = 0; $i <= $#pop; $i++) {
	for (my $g = $i + 1; $g <= $#pop; $g++) {
		my $pop1 = $pop[$i];
		my $pop2 = $pop[$g];
		my $str1 = join (",", @{$cls{$pop1}});
		my $str2 = join (",", @{$cls{$pop2}});
		print OUT " split/${pop1}_${pop2}";
	}
}
print OUT "\n\n";

for (my $i = 0; $i <= $#pop; $i++) {
	for (my $g = $i + 1; $g <= $#pop; $g++) {
		my $pop1 = $pop[$i];
		my $pop2 = $pop[$g];
		my $str1 = join (",", @{$cls{$pop1}});
		my $str2 = join (",", @{$cls{$pop2}});
		print OUT "nohup smc++ split -o split/${pop1}_${pop2} estimate/${pop1}/model.final.json estimate/${pop2}/model.final.json data/${pop1}_LG*.smc.gz data/${pop2}_LG*.smc.gz data/${pop1}_${pop2}_LG*.smc.gz data/${pop2}_${pop1}_LG*.smc.gz > log/smcpp_split_${pop1}_${pop2}.log 2>&1 &\n";
	}
}
close (OUT);
#####################################################################################################
printf STDERR "[total run time: %f s]\n", gettimeofday - $start_time;
__DATA__
Cn_TH_01	Cn_TH_01	Cn_TH
Cn_TH_02	Cn_TH_02	Cn_TH
Cn_TH_03	Cn_TH_03	Cn_TH
Cn_TH_04	Cn_TH_04	Cn_TH
Cn_TH_06	Cn_TH_06	Cn_TH
Cn_TH_07	Cn_TH_07	Cn_TH
Cn_TH_08	Cn_TH_08	Cn_TH
Cn_TH_09	Cn_TH_09	Cn_TH
Cn_TH_10	Cn_TH_10	Cn_TH
Cn_TH_11	Cn_TH_11	Cn_TH
Cn_TH_13	Cn_TH_13	Cn_TH
Cn_TH_14	Cn_TH_14	Cn_TH
Cn_TH_15	Cn_TH_15	Cn_TH
Cn_TH_16	Cn_TH_16	Cn_TH
Cn_TH_17	Cn_TH_17	Cn_TH
Cn_TH_18	Cn_TH_18	Cn_TH
Cn_TH_19	Cn_TH_19	Cn_TH
Cn_TH_20	Cn_TH_20	Cn_TH
Cn_TH_21	Cn_TH_21	Cn_TH
Cn_TH_22	Cn_TH_22	Cn_TH
Cn_TH_23	Cn_TH_23	Cn_TH
Cn_TH_24	Cn_TH_24	Cn_TH
Cn_TH_25	Cn_TH_25	Cn_TH
Cn_TH_26	Cn_TH_26	Cn_TH
Cn_TH_27	Cn_TH_27	Cn_TH
Cn_TH_28	Cn_TH_28	Cn_TH
Cn_TH_29	Cn_TH_29	Cn_TH
DH_DSH_03	DH_DSH_03	DH_DSH
DH_DSH_07	DH_DSH_07	DH_DSH
DSH_16	DSH_16	DH_DSH
DSH_31	DSH_31	DH_DSH
DSH_33	DSH_33	DH_DSH
DH_TH_01	DH_TH_01	DH_TH
DH_TH_02	DH_TH_02	DH_TH
DSH_01	DSH_01	DSH
DSH_02	DSH_02	DSH
DSH_04	DSH_04	DSH
DSH_08	DSH_08	DSH
DSH_12	DSH_12	DSH
DSH_15	DSH_15	DSH
DSH_18	DSH_18	DSH
DSH_19	DSH_19	DSH
DSH_23	DSH_23	DSH
DSH_29	DSH_29	DSH
DSH_32	DSH_32	DSH
HD_01	HD_01	HD
HD_02	HD_02	HD
HD_03	HD_03	HD
HD_04	HD_04	HD
HD_05	HD_05	HD
HD_06	HD_06	HD
HD_07	HD_07	HD
HD_08	HD_08	HD
HD_09	HD_09	HD
HD_10	HD_10	HD
HD_11	HD_11	HD
HD_12	HD_12	HD
HD_13	HD_13	HD
HD_14	HD_14	HD
HD_15	HD_15	HD
HD_16	HD_16	HD
HD_17	HD_17	HD
HD_18	HD_18	HD
HD_19	HD_19	HD
HD_20	HD_20	HD
HD_21	HD_21	HD
HD_22	HD_22	HD
HD_23	HD_23	HD
HD_24	HD_24	HD
HD_25	HD_25	HD
HD_26	HD_26	HD
HD_27	HD_27	HD
HD_28	HD_28	HD
HD_29	HD_29	HD
HD_30	HD_30	HD
JD_ZY_02	JD_ZY_02	JD_ZY
JD_ZY_07	JD_ZY_07	JD_ZY
JD_ZY_10	JD_ZY_10	JD_ZY
JD_ZY_11	JD_ZY_11	JD_ZY
JD_ZY_14	JD_ZY_14	JD_ZY
JD_ZY_18	JD_ZY_18	JD_ZY
JD_ZY_20	JD_ZY_20	JD_ZY
JD_ZY_22	JD_ZY_22	JD_ZY
JD_ZY_23	JD_ZY_23	JD_ZY
JD_ZY_31	JD_ZY_31	JD_ZY
JD_ZY_37	JD_ZY_37	JD_ZY
JD2_ZY01	JD2_ZY01	JD_ZY
JD2_ZY02	JD2_ZY02	JD_ZY
JD2_ZY03	JD2_ZY03	JD_ZY
JD2_ZY05	JD2_ZY05	JD_ZY
JD2_ZY12	JD2_ZY12	JD_ZY
JD2_ZY14	JD2_ZY14	JD_ZY
JD2_ZY25	JD2_ZY25	JD_ZY
JD2_ZY27	JD2_ZY27	JD_ZY
JD2_ZY29	JD2_ZY29	JD_ZY
JD2_ZY32	JD2_ZY32	JD_ZY
JD2_ZY34	JD2_ZY34	JD_ZY
JD2_ZY38	JD2_ZY38	JD_ZY
JD2_ZY39	JD2_ZY39	JD_ZY
JD2_ZY40	JD2_ZY40	JD_ZY
TZ_JD01	TZ_JD01	TZ
TZ_JD02	TZ_JD02	TZ
TZ_JD03	TZ_JD03	TZ
TZ_JD04	TZ_JD04	TZ
TZ_JD05	TZ_JD05	TZ
TZ_JD06	TZ_JD06	TZ
TZ_JD07	TZ_JD07	TZ
TZ_JD08	TZ_JD08	TZ
TZ_JD09	TZ_JD09	TZ
TZ_JD10	TZ_JD10	TZ
TZ_JD11	TZ_JD11	TZ
TZ_JD12	TZ_JD12	TZ
TZ_JD13	TZ_JD13	TZ
TZ_JD14	TZ_JD14	TZ
TZ_JD15	TZ_JD15	TZ
TZ_JD16	TZ_JD16	TZ
TZ_JD17	TZ_JD17	TZ
TZ_JD18	TZ_JD18	TZ
TZ_JD19	TZ_JD19	TZ
TZ_JD20	TZ_JD20	TZ
TZ_JD21	TZ_JD21	TZ
TZ_JD22	TZ_JD22	TZ
TZ_JD23	TZ_JD23	TZ
TZ_JD24	TZ_JD24	TZ
TZ_JD25	TZ_JD25	TZ
TZ_JD26	TZ_JD26	TZ
TZ_JD27	TZ_JD27	TZ
TZ_JD28	TZ_JD28	TZ
TZ_JD29	TZ_JD29	TZ
TZ_JD30	TZ_JD30	TZ