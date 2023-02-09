#!/usr/bin/perl

#use v5.10.0;
use strict;
use warnings;

open (INGFF,"<G:/grasscarp_8populations/manuscript/Scaffold/C_idella_female_genemodels.v1.gmap.gff");
open (INTXT,"<G:/grasscarp_8populations/manuscript/Scaffold/Cid_AnchorLGmapNew_0624_263scafford_out_v2.txt");
open (OUT,">G:/C_idella_female_genemodels.v1.gmap_changedposition_LG_v2.gff");
my @ingff=<INGFF>;
my @intxt=<INTXT>;

my $range=();
my %gff=();
foreach my $ingff(@ingff){
	chomp $ingff;
	my @gff=split (/\t/,$ingff);
	if ($gff[1] eq "Refseq"){
		$gff{$gff[0]}{"Refseq"}=$gff{$gff[0]}{"Refseq"}."\|".$ingff;
	}
	if ($gff[2] eq "gene"){
		$gff{$gff[0]}{"gene"}=$gff{$gff[0]}{"gene"}."\|".$ingff;
		$range="$gff[3] \- $gff[4]";
	}
	if ($gff[2] eq "exon" || $gff[2] eq "CDS"){
		$gff{$gff[0]}{$range}=$gff{$gff[0]}{$range}."\|".$ingff;
	}
}

my %hash=();
foreach my $txt_site(@intxt){
	chomp $txt_site;
	next if ($txt_site=~/^LG/);
	my @txt_site=split(/\t/,$txt_site);
	$hash{$txt_site[0]}= $txt_site[3]+$txt_site[2]-1;
}

foreach my $intxt(@intxt){
	chomp $intxt;
	next if ($intxt=~/^LG/);
	my @txt=split (/\t/,$intxt);
	print OUT "LG$txt[0]\tRefseq\tregion\t$txt[3]\t$hash{$txt[0]}\t.\t$txt[-1]\t.\tID=LG$txt[0]\n";
	if ($txt[-1] eq "+"){
		my @gff_gene=split(/\|/,$gff{$txt[1]}{"gene"});
		shift @gff_gene;
		foreach my $gff_gene(@gff_gene){
			my @gff_gene_splited=split(/\t/,$gff_gene);
			$gff_gene_splited[0]="LG$txt[0]";
			my @gff_majority=split(/\|/,$gff{$txt[1]}{"$gff_gene_splited[3] - $gff_gene_splited[4]"});
			shift @gff_majority;
			$gff_gene_splited[3]=$txt[3]+$gff_gene_splited[3]-1;
			$gff_gene_splited[4]=$txt[3]+$gff_gene_splited[4]-1;
			my $gff_gene_splited_joined=join("\t",@gff_gene_splited);
			print OUT "$gff_gene_splited_joined\n";
			
			foreach my $gff_majority(@gff_majority){
				my @gff_majority_splited=split(/\t/,$gff_majority);
				$gff_majority_splited[0]="LG$txt[0]";
				$gff_majority_splited[3]=$txt[3]+$gff_majority_splited[3]-1;
				$gff_majority_splited[4]=$txt[3]+$gff_majority_splited[4]-1;
				my $gff_majority_splited_joined=join("\t",@gff_majority_splited);
				print OUT "$gff_majority_splited_joined\n";
			}
		}
	}elsif ($txt[-1] eq "-"){
		my @gff_gene=split(/\|/,$gff{$txt[1]}{"gene"});
		shift @gff_gene;
		@gff_gene=reverse @gff_gene;
		foreach my $gff_gene(@gff_gene){
			my @gff_gene_splited=split(/\t/,$gff_gene);
			$gff_gene_splited[0]="LG$txt[0]";
			my @gff_majority=split(/\|/,$gff{$txt[1]}{"$gff_gene_splited[3] - $gff_gene_splited[4]"});
			shift @gff_majority;
#			@gff_majority=reverse @gff_majority;
			my $fh2=$gff_gene_splited[3];
			$gff_gene_splited[3]=$txt[3]+($txt[2]-$gff_gene_splited[4]);
			$gff_gene_splited[4]=$txt[3]+($txt[2]-$fh2);
			if ($gff_gene_splited[6] eq "+"){
				$gff_gene_splited[6]="-";
			}elsif($gff_gene_splited[6] eq "-"){
				$gff_gene_splited[6]="+";
			}
			my $gff_gene_splited_joined=join("\t",@gff_gene_splited);
			print OUT "$gff_gene_splited_joined\n";
			
			foreach my $gff_majority(@gff_majority){
				my @gff_majority_splited=split(/\t/,$gff_majority);
				$gff_majority_splited[0]="LG$txt[0]";
				my $fh3=$gff_majority_splited[3];
				$gff_majority_splited[3]=$txt[3]+($txt[2]-$gff_majority_splited[4]);
				$gff_majority_splited[4]=$txt[3]+($txt[2]-$fh3);
				if ($gff_majority_splited[6] eq "+"){
					$gff_majority_splited[6]="-";
				}elsif ($gff_majority_splited[6] eq "-"){
					$gff_majority_splited[6]="+";
				}
				
				my $gff_majority_splited_joined=join("\t",@gff_majority_splited);
				print OUT "$gff_majority_splited_joined\n";
			}
		}
	}else{
		print "ERROR!\n"
	}
}
close (INGFF);
close (INTXT);
close (OUT);






