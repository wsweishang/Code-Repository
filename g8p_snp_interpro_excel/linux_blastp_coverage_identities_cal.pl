##linux_blastp_coverage_cal.pl  <aa_length_list> <pal_blastp> XX XX 
#print STDERR ("\nperl linux_blastp_coverage_cal.pl  <aa_length_list> <blastp_m8> <identity_cutoff> <match_len_cutoff>\n");
#open aa_length_list,"$ARGV[0]" || die "Input file 0 cannot be opened.\n"; #>seq_id length
#open blastp,"$ARGV[1]" || die "Input file 0 cannot be opened.\n"; # alignment of gene models to known gene, -m 8
#$identity_cutoff=$ARGV[2];   # 0 <= $identity_cutoff <= 1
#$match_len_cutoff=$ARGV[3]; 
#
#open OUTPUT2,">$ARGV[1]_coverage_index" || die "Output file cannot be opened.\n"; 				
#
#print STDERR ("\n\nperl linux_blastp_coverage_cal.pl  <aa_length> <pal_blastp> XXX XXX \n\n");
#
#print STDERR ("START ! \n");
#print STDERR ("identity_cutoff= $identity_cutoff \n");
#print STDERR ("match_len_cutoff= $match_len_cutoff \n");
#
#foreach $a (<aa_length_list>) {
#	if ($a=~/>(\S+)\s+(\S+)/) {
#		chomp($a);
#		$gene=$1;
#		$gene_len{$gene}=$2;
#		next;
#	}
#	if ($a=~/>(\S+)\t+(\S+)/) {
#		chomp($a);
#		$gene=$1;
#		$gene_len{$gene}=$2;
#		next;
#	}
#	if ($a=~/(\S+)\s+(\S+)/) {
#		chomp($a);
#		$gene=$1;
#		$gene_len{$gene}=$2;
#		next;
#	}
#	if ($a=~/(\S+)\t+(\S+)/) {
#		chomp($a);
#		$gene=$1;
#		$gene_len{$gene}=$2;
#		next;
#	}
#}
#print STDERR ("aa_length_list OK!\n");
#
#foreach $a (<blastp>) {
#	if ($a=~/\#/) {
#			next;
#	}
#	
##	if ($a=~/contig/i || $a=~/scaf/i || $a=~/^BD/ || $a=~/^SB/ || $a=~/^OS/ || $a=~/^AT/ || $a=~/^PT/ || $a=~/^Si/ || $a=~/^ZM/ || $a=~/^Tea/) {
#		chomp($a);
#		@tmp=split(/\t+/,$a);
#		if ($tmp[0] eq $tmp[1]) {
#			next;
#		}
#		$gene=$tmp[0];
#		$homolog=$tmp[1];
#		$gene_homolog=$tmp[0]."XXX".$tmp[1];
#		$nt=$tmp[3];
#		$identity=$tmp[2]/100;
#		$alignedregion{$gene_homolog}=$alignedregion{$gene_homolog}." ".$tmp[6]."_".$tmp[7]."_".$identity;
##print STDERR ("$gene\t$alignedregion{$gene_homolog}\n");
##		$match_nt{$gene_homolog}=$match_nt{$gene_homolog}+int($nt*$identity);
##	}    
#}
#
#@gene_homolog_list=keys %alignedregion;
#@gene_homolog_list=sort{$a cmp $b} @gene_homolog_list;
#
#print OUTPUT2 ("Query_XXX_subject\tQuery_ref\tSubject\tQuery_len\tMatch_query_nt\tIdentity_ratio\tCoverage_ratio\tCov_region\n");
#	
#
#$n=0;
#foreach $gene_homolog (@gene_homolog_list) {
#	@tmp=split("XXX",$gene_homolog);
#	$gene=$tmp[0];
#	@splicing=split(" ",$alignedregion{$gene_homolog});
#	@splicing=sort {$a <=> $b} @splicing;
##print STDERR ("$gene_homolog\t$gene_len{$gene}\t$match_nt{$gene_homolog}\n");
#
#	$st=0;
#	$en=0;
#	$match_nt{$gene_homolog}=0;
#	$cov_region="";
#	$identity_len=0;
#	
#	foreach $b (@splicing) {
#		@ps=split("_",$b);
#		if ($st==0 && $en==0) {
#			$st=$ps[0];
#			$en=$ps[1];
#			$identity=$ps[2];
#			next;
#		}
#		if (($ps[0]-$en)>1) {
#			$match_nt{$gene_homolog}=$match_nt{$gene_homolog} + $en - $st + 1;
#			$cov_region=$cov_region."..".$st."_".$en;
#			$identity_len= $identity_len + ($en - $st + 1) * $identity;
#			$st=$ps[0];
#			$en=$ps[1];
#			$identity=$ps[2];
#			next;
#		}
#		else {
##			$identity_len= $identity_len + ($en - $st + 1) * $identity + ($ps[1] - $ps[0] + 1) * $ps[2] - ($en - $ps[0] + 1) * (($identity + $ps[2]) / 2);
#			$en=$ps[1];
#			next;
#		}
#	}
#	$identity_len= $identity_len + ($en - $st + 1) * $identity;
#	
#	$cov_region=$cov_region."..".$st."_".$en;
#	$cov_region=substr($cov_region,2);
#
#
#	
#	$match_nt{$gene_homolog}=$match_nt{$gene_homolog} + $en - $st + 1;
#	if ($gene_len{$gene} == 0) {
#		print STDERR ("Error! Length of $gene is zero\n");
#		next;
#	}
#	$coverage_ratio=int($match_nt{$gene_homolog}/$gene_len{$gene}*1000+0.5)/1000;
#	if ($coverage_ratio > 1) {
#		$coverage_ratio = 1;
#	}
#	$identity_ratio=int($identity_len/$gene_len{$gene}*1000+0.5)/1000;
#	if ($identity_ratio > 1) {
#		$identity_ratio = 1;
#	}
#	@aaa=split("XXX",$gene_homolog);
#	
##	if (($match_nt{$gene_homolog}/$gene_len{$gene}) > $identity_cutoff && $match_nt{$gene_homolog} > $match_len_cutoff/) {
#	if ($identity_ratio > $identity_cutoff && $match_nt{$gene_homolog} > $match_len_cutoff ) {
##	if (($match_nt{$gene_homolog}/$gene_len{$gene}) > $identity_cutoff && $index!~/$gene/) {
#		print OUTPUT2 ("$gene_homolog\t$aaa[0]\t$aaa[1]\t$gene_len{$gene}\t$match_nt{$gene_homolog}\t$identity_ratio\t$coverage_ratio\t$cov_region\n");
#		print STDERR ("$gene_homolog\t$gene_len{$gene}\t$match_nt{$gene_homolog}\n");
##		print OUTPUT1 (">$gene\t$gene_homolog\t$match_nt{$gene_homolog}\t$coverage_ratio\n");
##		print OUTPUT1 ("$gene_seq{$gene}\n");
##		if ($gene_seq{$gene}=~/^M/ && $gene_seq{$gene}=~/\*$/) {
##			$n++;
##		}
#	}
#}
##print STDERR ("$n\n");
#print STDERR ("FINISH	OK!\n");
#
#
