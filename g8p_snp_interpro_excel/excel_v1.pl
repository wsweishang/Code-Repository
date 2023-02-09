#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#mkdir ("G:/result") or die "$!";
open (OUT,">G:/result/1.txt") or die "$!";
open (ININTERPRODOMAIN,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/C_idella_female_InterproDomain.v1") or die "$!";

my %interprodomain=();
foreach my $ininterprodomain(<ININTERPRODOMAIN>){
	chomp $ininterprodomain;
	my @interprodomain=split(/\t/,$ininterprodomain);
	if ($interprodomain[11]){
		$interprodomain{$interprodomain[0]}="$interprodomain[11]";
	}
}

my @order=();
my %compare=();
my %hash=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file_a(@files){
	open (INCOMPARED,"<$file_a") or die "$!";
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
	undef (%compare);
}

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

print OUT "GeneID\t",join ("\t\t",@order),"\t\tInterpro","\n";
print OUT "\tExon\tOther" x56 ,"\n";
foreach my $k1(keys %hash){
	print OUT "$k1\t";
	foreach my $order(@order){
		if ($hash{$k1}{$order} eq "NA"){
			print OUT "NA\tNA\t";
		}else {
			my @array=split ("\t",$hash{$k1}{$order});
			my $n=@array;
			print "error: $k1\t$order\t$n\t@array\n" if ($n != 14);
			print OUT "$array[1] $array[3] $array[4] $array[5] $array[6] $array[8] $array[9] $array[10] $array[11]\t";
			print OUT "$array[0] $array[2] $array[7] $array[12] $array[13]\t";
		}
		
	}
	if (exists $interprodomain{$k1}){
		print OUT "$interprodomain{$k1}";
	}else{
		print OUT "NA";
	}
	print OUT "\n";
}

close (ININTERPRODOMAIN);
close (INCOMPARED);
close (INCOMPARE);
close (OUT);
