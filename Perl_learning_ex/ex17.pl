#!/perl/bin/perl
  
use strict;
  
my $temp_file = "test.xml";
my $file_name = "test81801.xml";
my ($holdTerminator) = $/;
my $buf= "";
my ($res) = "";
	$/ = "\n";
	open (OUTPUT,">",$file_name)  or die "Couldn't open $file_name for writing: $!\n" ;
	open (FIC_AVANT,"<",$temp_file) or die "Problem in read_template to open file $temp_file $!\n" ; 		  		  
	my $len=0;
	my $buflen = 10*1024*1024;
	while (($len = read FIC_AVANT, $buf, $buflen) != 0) {
		  #chomp $buf;
			my ($lbuf, $ldata, $ln, $prechar,$endFlag);
      $endFlag = 0;
			$prechar = '';
			$lbuf = "";
			while ($endFlag==0 && ($ln = read FIC_AVANT, $ldata, 1) != 0) {
  		#chomp($ldata);	
  		$lbuf .= $ldata;
  		if($ldata eq '/'){
				$prechar = '/';
      }
      if($prechar eq '/' && $ldata eq '>'){
      	$endFlag = 1;
        $prechar = "";
        $ldata = "";
        print "$lbuf appended after reading.\n"; 	
        }                
			}
			chomp($lbuf);
			print("$len read this time and the content in the line is:$lbuf!\n");
		  $buf .= $lbuf;		
			$_ = $buf; 
			s{<(.*?)>performancecounterfilegeneratorfunction (.*?)</\1>}{
			#print("$1 matched!");
			  $res = eval "$2" ;
			  "<$1>$res</$1>" ;
			}egx;
			s/^\n//;
			print OUTPUT $_; 
			$buf = ""; 
			# my $curposition=tail(FIC_AVANT);
			# print("$curposition is current read position!\n");
			#seek (FIC_AVANT,$curposition,0);
	} 
 	$/ = $holdTerminator; 	
close(OUTPUT) ;
close(FIC_AVANT); 
  
  
  
  
  
  
  
  