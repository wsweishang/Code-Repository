#!/usr/bin/perl
use strict;
use Tk;

my $Main = new MainWindow;
my ($tf,$frame,$dot,$temp,$expression,$equal) = (0,0,0,0,0,1);

$Main -> title('Calculating Machine');
$tf = $Main -> Entry(-disabledbackground => 'white', -disabledforeground => 'black', 
			-justify => 'right', -width => 20, -textvariable => \$expression, -state => 'disabled') 
			-> pack();
$frame = $Main -> Frame() -> pack(-side => "bottom", -padx => 5);
$frame -> Button(-text => "<-", -command => sub{
			$tf -> configure(-state => 'normal');
			my $delete_first = length($tf -> get);
			if ($expression =~ /\.$/){
				$dot -> configure(-state => 'normal');
			}
			$tf -> delete($delete_first-1);
			if ($expression == undef){
				$expression = 0;
				$equal = 1;
			}
			$tf -> configure(-state => 'disabled');
			}) 
			-> grid(-row => 0, -column => 0);
$frame -> Button(-text => "C", -command => sub{
				$dot -> configure(-state => 'normal');
				$equal = 1;
				$expression = 0;
				}) 
			-> grid(-row => 0, -column=>1, -rowspan=>1,-columnspan=>2, -sticky=>'nwse');
$frame -> Button(-text => "=", -command => sub{
				$dot -> configure(-state => 'normal');
				if (!(my $result = eval $expression)){
					$expression = 'ERROR';
				} else {
					$expression = $result;
				}
				if ($expression =~ /\./){
					$dot -> configure(-state => 'disabled');
				}
				$equal = 1;
				}) 
			-> grid(-row => 0, -column => 3);
$frame -> Button(-text => "7", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','7');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 1, -column => 0);
$frame -> Button(-text => "8", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','8');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 1, -column => 1);
$frame -> Button(-text => "9", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','9');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 1, -column => 2);
$frame -> Button(-text => "/", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$equal = 0;
			}
			$dot -> configure(-state => 'normal');
			$tf -> insert('end','/');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 1, -column => 3);
$frame -> Button(-text => "4", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','4');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 2, -column => 0);
$frame -> Button(-text => "5", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','5');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 2, -column => 1);
$frame -> Button(-text => "6", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','6');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 2, -column => 2);
$frame -> Button(-text => "*", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$equal = 0;
			}
			$dot -> configure(-state => 'normal');
			$tf -> insert('end','*');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 2, -column => 3);
$frame -> Button(-text => "1", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','1');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 3, -column => 0);
$frame -> Button(-text => "2", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','2');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 3, -column => 1);
$frame -> Button(-text => "3", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$expression = undef;
				$equal = 0;
			}
			$tf -> insert('end','3');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 3, -column => 2);
$frame -> Button(-text => "-", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$equal = 0;
			}
			$dot -> configure(-state => 'normal');
			$tf -> insert('end','-');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 3, -column => 3);
$frame -> Button(-text => "0", -command => sub{
			$tf -> configure(-state => 'normal');
			$tf -> insert('end','0');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 4, -column => 0);
$frame -> Button(-text => "+/-", -command => sub{
			my $sign;
			if ($expression =~ /^-/){
				$sign = 1;
			} else {
				$sign = 0;
			}
			$expression =~ tr/\+\-/\-\+/;
			if ($sign == 1){
				$expression =~ s/^\+//;
			} else {
				$expression = -$expression;
			}
			}) -> grid(-row => 4, -column => 1);
$dot = $frame -> Button(-text => ".", -command => sub{
			$tf -> configure(-state => 'normal');
			$tf -> insert('end','.');
			$tf -> configure(-state => 'disabled');
			$dot -> configure(-state => 'disabled');}) 
			-> grid(-row => 4, -column => 2);
$frame -> Button(-text => "+", -command => sub{
			$tf -> configure(-state => 'normal');
			if ($equal == 1)
			{
				$equal = 0;
			}
			$dot -> configure(-state => 'normal');
			$tf -> insert('end','+');
			$tf -> configure(-state => 'disabled');}) 
			-> grid(-row => 4, -column => 3);


$Main -> MainLoop;
1;
