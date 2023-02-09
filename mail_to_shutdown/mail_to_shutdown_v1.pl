#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(gettimeofday tv_interval);
use Mail::POP3Client;
use MIME::Parser;
use MIME::Entity;
use IPC::System::Simple qw(systemx);

my $host = "pop.163.com";
my $user = "wswsweishang";
my $pass = "ESGZLNCITURCFPOH";

while () {
	my $client = new Mail::POP3Client ($user, $pass, $host);
	my $parser = MIME::Parser -> new;
	my $mgrnum = $client -> Count;
	my $headandbody = $client -> HeadAndBody($mgrnum);
	my $entity = $parser -> parse_data($headandbody);
	$parser -> decode_headers(1);
	my $fh = $entity -> head -> get('Subject');
	$fh =~ s/\n//;
	print "total [$mgrnum] letters\n";
	if ($fh =~ /shutdown/) {
		print "object match\n";
		system ("shutdown -s -t 10 -c 收到邮件关机指令，即将关机");
	} elsif ($fh =~ /restart/) {
		print "object match\n";
		system ("shutdown -r -t 10 -c 收到邮件重启指令，即将重启");
	} else {
		print "object unmatch\n"
	}
	sleep (10);
}


