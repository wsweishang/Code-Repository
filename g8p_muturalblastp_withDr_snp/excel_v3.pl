#!/usr/bin/perl

use strict;
use warnings;

open (OUT,">G:/Grasscarp_8populations_comprehensive_matrix.txt") or die "$!";
open (ININTERPRODOMAIN,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/C_idella_female_InterproDomain.v1") or die "$!";
open (INGC,"<G:/Query_Grasscarp_blastpwith_Subject_Daniorerio_1e10_m8_20190807.output_coverage_index_sorted_top") or die "$!";
open (INDR,"<G:/Query_Daniorerio_blastpwith_Subject_Grasscarp_1e10_m8_20190808.output_coverage_index_sorted_top") or die "$!";
#================================================================================================================
my %gc=();
foreach my $ingc(<INGC>){
	chomp $ingc;
	next if ($ingc!~/^CI.*/);
	my @ingc=split (/\t/,$ingc);
	$gc{$ingc[1]}{$ingc[2]}=$ingc[5];
}
close (INGC);
#================================================================================================================
my %dr=();
foreach my $indr(<INDR>){
	chomp $indr;
	next if ($indr!~/^EN.*/);
	my @indr=split (/\t/,$indr);
	$dr{$indr[2]}{$indr[1]}=$indr[5];
}
close (INDR);
#================================================================================================================
my %interprodomain=();
foreach my $ininterprodomain(<ININTERPRODOMAIN>){
	chomp $ininterprodomain;
	my @interprodomain=split(/\t/,$ininterprodomain);
	if ($interprodomain[11]){
		$interprodomain{$interprodomain[0]}="$interprodomain[11]";
	}
}
close (ININTERPRODOMAIN);
#================================================================================================================
my @order=();
my %compare=();
my %hash=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file_a(@files){
	open (INCOMPARED,"<$file_a") or die "$!";
	undef %compare;
	foreach my $content_a(<INCOMPARED>){
		chomp $content_a;
		next if ($content_a=~/^#.*/);
		my @content_a_splited=split(/\t/,$content_a);
		next if ($content_a_splited[1]=~/.*circ$/);
		$compare{$content_a_splited[0]}="NA";
	}
	foreach my $file_b(@files){
		next if ($file_a eq $file_b);
		open (INCOMPARE,"<$file_b") or die "$!";
		my @file_a=split (/\//,$file_a);
		my @file_b=split (/\//,$file_b);
		my $a=pop @file_a;
		my $b=pop @file_b;
		$a=substr($a,0,2);
		$b=substr($b,0,2);
		push(@order,"$b vs $a");
		foreach my $content_b(<INCOMPARE>){
			chomp $content_b;
			next if ($content_b=~/^#.*/);
			my @content_b_splited=split(/\t/,$content_b);
			next if ($content_b_splited[1]=~/.*circ$/);
			unless (exists $compare{$content_b_splited[0]}){
				my @fh=split (/\t/,$content_b);
				my $fh=join ("\t",@fh[8..21]);
				$hash{$content_b_splited[0]}{"$b vs $a"}=$fh;
			}
		}
	}
	undef %compare;
}
close (INCOMPARE);
#================================================================================================================
foreach my $file(@files){
	open (INCOMPARED,"<$file");
	foreach my $content(<INCOMPARED>){
		chomp $content;
		next if ($content=~/^#.*/);
		my @content_splited=split(/\t/,$content);
		next if ($content_splited[1]=~/.*circ$/);
		foreach my $order(@order){
			unless (exists $hash{$content_splited[0]}{$order}){
				$hash{$content_splited[0]}{$order}="NA";
			}
		}
	}
}
close (INCOMPARED);
#================================================================================================================
print OUT "GeneID\t",join ("\t\t",@order),"\t\tInterpro","\tblastp\t","\tDanio rerio","\n";
print OUT "\tExon\tOther" x56 ,"\t\tquery_Dr\tquery_Gc\t","\n";
foreach my $k1(keys %hash){
	print OUT "$k1\t";
	foreach my $order(@order){
		if ($hash{$k1}{$order} eq "NA"){
			print OUT "NA\tNA\t";
		}else {
			my @array=split ("\t",$hash{$k1}{$order});
			my $n=@array;
			print "error: $k1\t$order\t$n\t@array\n" if ($n != 14);
			print OUT "$array[1]..initiator_codon_variant $array[3]..missense_variant $array[4]..non_canonical_start_codon $array[5]..splice_acceptor_variant $array[6]..splice_donor_variant $array[8]..start_lost $array[9]..stop_gained $array[10]..stop_lost $array[11]..stop_retained_variant\t";
			print OUT "$array[0]..downstream_gene_variant $array[2]..intron_variant $array[7]..splice_region_variant $array[12]..synonymous_variant $array[13]..upstream_gene_variant\t";
		}
	}
	if (exists $interprodomain{$k1}){
		print OUT "$interprodomain{$k1}\t";
	}else{
		print OUT "NA\t";
	}
	if (exists $gc{$k1} and exists $dr{$k1}){
		my @m=keys %{$gc{$k1}};
		if (exists $dr{$k1}{$m[0]}){
			print OUT "$dr{$k1}{$m[0]}\t$gc{$k1}{$m[0]}\t$m[0]";
		}else{
			print OUT "NA\tNA\tNA";
		}
	}
	else{
		print OUT "NA\tNA\tNA";
	}
	print OUT "\n";
}
#================================================================================================================
close (OUT);
