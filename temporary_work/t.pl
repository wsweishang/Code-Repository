#!/usr/bin/perl

use strict;
sub ridit{    
   my ($i,$sum_total,$sum_ref,$sum_snp,$cumsum,$num,$m,$cumfr,$cumfrr,$r_ref,$r_snp,$var,$z,$u,$p);
   my (@a,@sum,@r,@cumsum);
   $num= @_;
   for $i(0...$num-1){      
       $a[$i]=shift @_;
       $sum_total+=$a[$i];
       if($i%2==0){
         $sum_ref+=$a[$i];
      }
      if($i%2==1)
      {$sum_snp+=$a[$i];}
   }
#   print "@a\t$sum_total\t$sum_ref\t$sum_snp\n";
      $cumsum[0]=0;
      while($i<$num){
      $m=$i/2;
      $sum[$m]=$a[$i]+$a[$i+1];
      
#      print "\$sum[$m]\t\$a[$i]\t\$a[$i+1]\n";
#      print "$sum[$m]\t$a[$i]\t$a[$i+1]\n";
      
      $cumsum[$m+1]=$cumsum[$m]+$sum[$m] if $m+1<$num/2;
      
#      print "\$cumsum[$m+1]\t\$cumsum[$m]\t\$sum[$m]\n";
#      print "$cumsum[$m+1]\t$cumsum[$m]\t$sum[$m]\n";
#      print "@cumsum\n";
      
      $r[$m]=($cumsum[$m]+$sum[$m]/2)/$sum_total;
      
#      print "\$r[$m]=(\$cumsum[$m]+\$sum[$m]/2)/\$sum_total\n";
#      print "$r[$m]=($cumsum[$m]+$sum[$m]/2)/$sum_total\n";
#      print "@r\t$sum_total\n";
      
      $cumfr+=$sum[$m]*$r[$m];
      
#      print "$cumfr+=$sum[$m]*$r[$m]\n";
      
      $cumfrr+=$sum[$m]*$r[$m]*$r[$m];
      
#      print "$cumfrr+=$sum[$m]*$r[$m]*$r[$m]\n";
      
      $r_ref+=($a[$i]*$r[$m]/$sum_ref);
      $r_snp+=($a[$i+1]*$r[$m]/$sum_snp);
      
#      print "\$r_ref+=(\$a[$i]*\$r[$m]/\$sum_ref)\n";
#      print "$r_ref+=($a[$i]*$r[$m]/$sum_ref)\n";
      
#      print "\$r_snp+=(\$a[$i+1]*\$r[$m]/\$sum_snp)\n";
#      print "$r_snp+=($a[$i+1]*$r[$m]/$sum_snp)\n";
      
      $i+=2;
      }
#      print "@r\n";
      
      $var=($cumfrr-$cumfr*$cumfr/$sum_total)/($sum_total-1);
      
#      print "$var\n";
      
      $z=abs($r_ref-$r_snp)/sqrt($var*$sum_total/($sum_ref*$sum_snp));
      $u=abs($r_ref-$r_snp)/sqrt((1/12)*$sum_total/($sum_ref*$sum_snp));
#      use Statistics::Distributions;
#      $p=Statistics::Distributions::uprob($z);
      $p=$z;
#      print "$z\n";
      return($p);
}
my ($file,$result,$p);
my (@order,@line,@lines,@d,@order_d);
$file=shift;
open (IN,"$file");
@order=@ARGV;
chomp(@line=<IN>);
foreach (@line){ 
   @lines=split/\t/,$_;
   for(@lines){    
      if(/[01]\/[01]:(\d+),(\d+)/g){      
         push @d,$1,$2;
      }
   }
   for (@order){
      push @order_d,$d[2*$_-2],$d[2*$_-1]; 
   }  
   $p=&ridit(@order_d);
   $result=-log($p);
   if(/chromosome(\d+)\s(\d+)/){            
#      print "$1\t$2\t$result\n";
   }
   @d=();
   @order_d=();
} 
close(IN);