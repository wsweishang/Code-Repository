#!/usr/bin/perl

&USAGE if ($ARGV[0] eq "help");

open (INFASTA,"<$ARGV[0]") or die "$!";
open (INVCF,"<$ARGV[1]") or die "$!";
open (INTXT,"<$ARGV[2]") or die "$!";
open (OUT,">$ARGV[3]") or die "$!";
my $pace=$ARGV[4];
my $threshold=$ARGV[5];
my @infasta=(<INFASTA>);
my @invcf=(<INVCF>);
my @intxt=(<INTXT>);
#===============================================================
my %seq=();
my $fasta_ID=();
foreach my $infasta(@infasta){
	chomp $infasta;
	if ($infasta=~/^>.*/){
		$fasta_ID=substr($infasta,1);
	}
	$seq{$fasta_ID}=$infasta;
}
close (INFASTA);
#===============================================================
my %snp=();
my @vcf=();
foreach my $invcf(@invcf){
	chomp $invcf;
	next if ($invcf=~/^#.*/);
	@vcf=split(/\t/,$invcf);
	$snp{$vcf[0]}=$snp{$vcf[0]}."\t".$vcf[1];
}
close (INVCF);
#===============================================================
print OUT "LG\tscaffold_ID\trange\tsnp_num/effective_length\n";
my @txt=();
foreach my $intxt(@intxt){
	chomp $intxt;
	next unless ($intxt=~/^[0-9]+/);
	@txt=split(/\t/,$intxt);
	my @loci=split(/\t/,$snp{$txt[1]});
	my $useless=shift @loci;
#	print OUT @loci;
	if ($txt[4] gt "-"){
		foreach my $loci(@loci){
#			print OUT $txt[1]."\t".$loci."\n";
			$loci=$txt[2] - $loci + 1;
			$i = int ($loci-1)/$pace;
			$count[$i]=$count[$i]+1;
		}
		my $rev_seq=reverse $seq{$txt[1]};
		my $start=();
		my $end=();
		for ($i=0;$end<=$txt[2];$i++){
			$start=($i*$pace)+1;
			$end=($i+1)*$pace;
			my $substr=substr ($rev_seq,$i*$pace,$pace);
			$substr=~s/N//g;
			my $threshold_n_number=$pace*$threshold;
			my $except_n_number=length $substr;
			if ($except_n_number>=$threshold_n_number){
#				print OUT $except_n_number;
				$result=$count[$i]/$except_n_number;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}elsif ($except_n_number<$threshold_n_number){
#				print OUT $except_n_number;
				$result=0;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";	
			}
			if ($txt[2]-$end<=$pace){
				my $substr=substr ($rev_seq,$end);
				$substr=~s/N//g;
				my $threshold_n_number=($txt[2]-$end)*$threshold;
				my $except_n_number=length $substr;
				my $difference=$end+1;
				$i=$i+1;
				if ($except_n_number>=$threshold_n_number){
#					print OUT $except_n_number;
					$result=$count[$i]/$except_n_number;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";
				}elsif ($except_n_number<$threshold_n_number){
#					print OUT $except_n_number;
					$result=0;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";	
				}	
			}
			last if ($txt[2]-$end<=$pace);
		}
	}elsif ($txt[4] gt "+"){
		foreach my $loci(@loci){
#			print OUT $txt[1]."\t".$loci."\n";
			$i = int ($loci-1)/$pace;
			$count[$i]=$count[$i]+1;
		}
		my $rev_seq=$seq{$txt[1]};
		my $start=();
		my $end=();
		for ($i=0;$end<=$txt[2];$i++){
			$start=($i*$pace)+1;
			$end=($i+1)*$pace;
			my $substr=substr ($rev_seq,$i*$pace,$pace);
			$substr=~s/N//g;
			my $threshold_n_number=$pace*$threshold;
			my $except_n_number=length $substr;
			if ($except_n_number>=$threshold_n_number){
#				print OUT $except_n_number;
				$result=$count[$i]/$except_n_number;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}elsif ($except_n_number<$threshold_n_number){
#				print OUT $except_n_number;
				$result=0;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";	
			}
			if ($txt[2]-$end<=$pace){
				my $substr=substr ($rev_seq,$end);
				$substr=~s/N//g;
				my $threshold_n_number=($txt[2]-$end)*$threshold;
				my $except_n_number=length $substr;
				my $difference=$end+1;
				$i=$i+1;
				if ($except_n_number>=$threshold_n_number){
#					print OUT $except_n_number;
					$result=$count[$i]/$except_n_number;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";
				}elsif ($except_n_number<$threshold_n_number){
#					print OUT $except_n_number;
					$result=0;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";	
				}	
			}
			last if ($txt[2]-$end<=$pace);
		}
	}
	undef @count;
}
close (INTXT);
close (OUT);

sub USAGE{
	my $usage=<<USAGE;
===================================================================================================================
 __        __   _     _                                                        _       
 \ \      / /__(_)___| |__   __ _ _ __   __ _    _ __  _ __ ___  ___  ___ _ __ | |_ ___ 
  \ \ /\ / / _ \ / __| '_ \ / _` | '_ \ / _` |  | '_ \| '__/ _ \/ __|/ _ \ '_ \| __/ __|
   \ V  V /  __/ \__ \ | | | (_| | | | | (_| |  | |_) | | |  __/\__ \  __/ | | | |_\__ \
    \_/\_/ \___|_|___/_| |_|\__,_|_| |_|\__, |  | .__/|_|  \___||___/\___|_| |_|\__|___/
                                        |___/   |_|               _ 
  _   _ ___  __ _  __ _  ___    _ __ ___   __ _ _ __  _   _  __ _| |
 | | | / __|/ _` |/ _` |/ _ \  | '_ ` _ \ / _` | '_ \| | | |/ _` | |
 | |_| \__ \ (_| | (_| |  __/  | | | | | | (_| | | | | |_| | (_| | |
  \__,_|___/\__,_|\__, |\___|  |_| |_| |_|\__,_|_| |_|\__,_|\__,_|_|
                  |___/                                                                                   
===================================================================================================================
1.FUNCTION:
	This Perlscript carries out SNP interval density statistics at chromosome level and draws SNP thermogram.
===================================================================================================================	
2.INPUT FILES AND PARAMETERS:
	-ARGV[0] -> FASTA FILEPATH
	-ARGV[1] -> VCF FILEPATH
	-ARGV[2] -> TXT FILEPATH 
	-ARGV[3] -> OUTPUT FILEPATH AND FILENAME
	-ARGV[4] -> PACE(?bp)
	-ARGV[5] -> THRESHOLD(VALID LENGTH)(0.?)
===================================================================================================================
3.INPUT TXT FILE FORMAT:(5 columns)
	LG	scaffold_ID	length	startsite	+/-
	1	CI01000342	173664	1	+
	1	CI01000105	3526334	173765	+
	1	CI01000103	414537	3700199	-
	1	CI01000200	782515	4114836	+
===================================================================================================================
4.OUTPUT FILE FORMAT:(4 columns)
	LG	scaffold_ID	range	snp_num/effective_length
	01	CI01000342	1 - 500	0.0000
	01	CI01000342	501 - 1000	0.0000
	01	CI01000342	1001 - 1500	0.0000
	01	CI01000342	1501 - 2000	0.0000
	01	CI01000342	2001 - 2500	0.0060
	01	CI01000342	2501 - 3000	0.0100
	01	CI01000342	3001 - 3500	0.0040
	01	CI01000342	3501 - 4000	0.0000
	01	CI01000342	4001 - 4500	0.0040
	01	CI01000342	4501 - 5000	0.0020
	01	CI01000342	5001 - 5500	0.0020
	01	CI01000342	5501 - 6000	0.0000
	01	CI01000342	6001 - 6500	0.0040
	01	CI01000342	6501 - 7000	0.0020
	01	CI01000342	7001 - 7500	0.0060
===================================================================================================================	
5.EMERGENCY PHONE CALL:
	Ask for help by taking a phone call as a last resort: 18838922896.
===================================================================================================================
USAGE
	print $usage;
	exit;
}


