#!/usr/bin/perl

#use strict;
#use warnings;

open (INFASTA,"</home/yinglu/grasscarp_reseq_8populations/Snp_Indel_263Scafford/Cid_AnchorLGmapNew_0624_263scafford_GoldenpathonLGmap.fasta") or die "$!";
open (OUT,">$ARGV[0]") or die "$!";
my $pace=$ARGV[1];
my $threshold=$ARGV[2];
#===============================================================
my %seq=();
my $fasta_ID=();
my @LG_order=();
my $i=0;
foreach my $infasta(<INFASTA>){
	chomp $infasta;
	if ($infasta=~/^>(.*)/){
		$fasta_ID=$1;
		$LG_order[$i]=$fasta_ID;
		$i++;
	}
	else{
		$seq{"$fasta_ID"}=$infasta;
	}
}
close (INFASTA);
#===============================================================
my @files=glob "$ARGV[3]/*.snp.eff.vcf";
my $q=0;
my %snp=();
my @vcf=();
my @population_order=();
foreach my $file(@files){
	open (IN,"<$file") or die "$!";
	$file=~/\/([A-Z]{2}).*/;
	$population_order[$q]=$1;
	foreach my $invcf(<IN>){
		chomp $invcf;
		next if ($invcf=~/^#.*/);
		@vcf=split(/\t/,$invcf);
		$snp{$population_order[$q]}{$vcf[0]}=$snp{$population_order[$q]}{$vcf[0]}."\t".$vcf[1];
	}
	$q++;
}
close (IN);
#===============================================================
print OUT "#snpdensity matrix of g8p counted by LG fasta file\n";
print OUT "#pace => $pace\n";
print OUT "#threshold(effective_length/overall length) => $threshold\n";
print OUT "#LG\trange\t",join ("\t",@population_order),"\n";

foreach my $LG_order(@LG_order){
	my $length=length $seq{$LG_order};
	foreach my $order(@population_order){
		my @loci=split(/\t/,$snp{$order}{$LG_order});
		shift @loci;
		foreach my $loci(@loci){
			my $i=int (($loci-1)/$pace);
			${$order}[$i]++;
		}
	}
	my $rev_seq=$seq{$LG_order};
	my $start=0;
	my $end=0;
	for ($i=0;$end<=$length;$i++){
		$start=($i*$pace)+1;
		$end=($i+1)*$pace;
		my $substr=substr ($rev_seq,$i*$pace,$pace);
		$substr=~s/N//g;
		my $threshold_n_number=$pace*$threshold;
		my $except_n_number=length $substr;
		print OUT "$LG_order\t$start - $end";
		foreach my $order(@population_order){
			if ($except_n_number>=$threshold_n_number){
				my $result=${$order}[$i]/$except_n_number;
				$result=sprintf "%.4f",$result;
				print OUT "\t$result";
			}else{
				my $result=0;
				$result=sprintf "%.4f",$result;
				print OUT "\t$result";	
			}
		}
		print OUT "\n";
		if ($length-$end<=$pace){
			my $substr=substr ($rev_seq,$end);
			$substr=~s/N//g;
			my $threshold_n_number=($length-$end)*$threshold;
			my $except_n_number=length $substr;
			my $difference=$end+1;
			$i=$i+1;
			print OUT "$LG_order\t$difference - $length";
			foreach my $order(@population_order){
				if ($except_n_number>=$threshold_n_number){
					my $result=${$order}[$i]/$except_n_number;
					$result=sprintf "%.4f",$result;
					print OUT "\t$result";
				}else{
					my $result=0;
					$result=sprintf "%.4f",$result;
					print OUT "\t$result";	
				}
			}
		print OUT "\n";	
		}
		last if ($length-$end<=$pace);
	}
	foreach my $order(@population_order){
		undef @{$order};
	}
}
close (OUT);


