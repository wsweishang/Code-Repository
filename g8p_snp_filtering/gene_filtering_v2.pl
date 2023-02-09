#!/usr/bin/perl

use strict;
use warnings;

open (ININTERPRODOMAIN,"<G:/grasscarp_8populations/manuscript/SNP_INDEL/C_idella_female_InterproDomain.v1");
open (OUT3,">G:/3.txt");
open (OUT4,">G:/4.txt");

my %interprodomain=();
foreach my $ininterprodomain(<ININTERPRODOMAIN>){
	chomp $ininterprodomain;
	my @interprodomain=split(/\t/,$ininterprodomain);
	if ($interprodomain[12]){
		$interprodomain{$interprodomain[0]}="$interprodomain[12]";
	}
}

my %gene=();
my @count=();
print OUT3 "GO annotation\t\t\t\t\t\t\t\t\tdownstream_gene_variant\tinitiator_codon_variant\tintron_variant\tmissense_variant\tnon_canonical_start_codon\tsplice_acceptor_variant\tsplice_donor_variant\tsplice_region_variant\tstart_lost\tstop_gained\tstop_lost\tstop_retained_variant\tsynonymous_variant\tupstream_gene_variant";
my %compared_data=();
my @files=glob "G:/grasscarp_8populations/manuscript/SNP_INDEL/snp/*.txt";
foreach my $file_a(@files){
	open (INCOMPARED,"<$file_a");
	my @compared_file=<INCOMPARED>;
	foreach my $compared_data(@compared_file){
		chomp $compared_data;
		next if ($compared_data=~/^#.*/);
		my @compared_content=split(/\t/,$compared_data);
		next if ($compared_content[1]=~/.*circ$/);
		$compared_data{$compared_content[0]}=1;
	}
	foreach my $file_b(@files){
		next if ($file_a eq $file_b);
		open (INCOMPARE,"<$file_b");		
		my @file_a=split (/\//,$file_a);
		my @file_b=split(/\//,$file_b);
		my $a=pop @file_a;
		my $b=pop @file_b;
		$a=substr($a,0,2);
		$b=substr($b,0,2);
		print OUT3 "\n>$b vs $a\n";
		print OUT4 "\n>$b vs $a\n";
		my @compare_file=<INCOMPARE>;
		foreach my $compare_data(@compare_file){
			chomp $compare_data;
			next if ($compare_data=~/^#.*/);
			my @compare_content=split(/\t/,$compare_data);
			next if ($compare_content[1]=~/.*circ$/);
			unless (exists $compared_data{$compare_content[0]}){
				if (exists $interprodomain{$compare_content[0]}){
					my @count=split(/\t/,$gene{$interprodomain{$compare_content[0]}});
					foreach my $i(8..21){
						$count[$i] += $compare_content[$i];
					}
					$gene{$interprodomain{$compare_content[0]}}=join("\t",@count);
				}else{
					print OUT4 "$compare_content[0]\n";
				}
			}
		}
		foreach my $k(keys %gene){
			print OUT3 "$k\t$gene{$k}\n";
		}
		undef %gene;
	}
}

close (ININTERPRODOMAIN);
close (INCOMPARED);
close (OUT3);
close (OUT4);


