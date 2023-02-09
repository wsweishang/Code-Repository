#!/usr/bin/perl

open (INFASTA,"</home/yinglu/grasscarp_reseq_8populations/C_idella_female_scaffolds.fasta.v1") or die "$!";
open (INVCF,"<$ARGV[0]") or die "$!";
open (INTXT,"</home/yinglu/grasscarp_reseq_8populations/linkage_groups/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmapScaffoldLoci.txt") or die "$!";
open (OUT,">$ARGV[1]") or die "$!";
my $pace=$ARGV[2];
my $threshold=$ARGV[3];
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


