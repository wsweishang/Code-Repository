#!/usr/bin/perl

open (INFASTA,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_scaffolds.fasta.v1") or die "$!";
open (INVCF,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/AX_S4.bcftools_maf_DP_snp_filter.snpEff.vcf") or die "$!";
open (INTXT,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt") or die "$!";
open (OUT,">G:/1.txt") or die "$!";
my $pace=500;
my $threshold=100;
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
	if ($txt[-1] eq "-"){
		foreach my $loci(@loci){
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
			my $except_n_number=length $substr;
			if ($except_n_number>=$threshold){
				$result=$count[$i]/$except_n_number;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}elsif ($except_n_number<$threshold){
				$result=0;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";	
			}
			if ($txt[2]-$end<=$pace){
				my $substr=substr ($rev_seq,$end);
				$substr=~s/N//g;
				my $except_n_number=length $substr;
				my $difference=$end+1;
				$i=$i+1;
				if ($except_n_number>=$threshold){
					$result=$count[$i]/$except_n_number;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";
				}elsif ($except_n_number<$threshold){
					$result=0;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";	
				}	
			}
			last if ($txt[2]-$end<=$pace);
		}
	}
	if ($txt[-1] eq "+"){
		foreach my $loci(@loci){
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
			my $except_n_number=length $substr;
			if ($except_n_number>=$threshold){
				$result=$count[$i]/$except_n_number;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";
			}elsif ($except_n_number<$threshold){
				$result=0;
				$result=sprintf "%.4f",$result;
				print OUT "$txt[0]\t$txt[1]\t$start - $end\t$result\n";	
			}
			if ($txt[2]-$end<=$pace){
				my $substr=substr ($rev_seq,$end);
				$substr=~s/N//g;
				my $except_n_number=length $substr;
				my $difference=$end+1;
				$i=$i+1;
				if ($except_n_number>=$threshold){
					$result=$count[$i]/$except_n_number;
					$result=sprintf "%.4f",$result;
					print OUT "$txt[0]\t$txt[1]\t$difference - $txt[2]\t$result\n";
				}elsif ($except_n_number<$threshold){
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



