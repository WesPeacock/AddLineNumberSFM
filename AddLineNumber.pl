#!/usr/bin/env perl
my $USAGE = "Usage: $0 [--flgmarks lx] [--help] [--debug] [file.sfm]";

use 5.022;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;
use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl
use Getopt::Long;
GetOptions (
	'flgmarks:s' => \(my $flgmarks = "lx"), # record marker, default lx
# 'sampleoption:s' => \(my $sampleoption = "optiondefault"),
# additional options go here.

	# Be aware # is the bash comment character, so quote it if you want to specify it.
	#	Better yet, just don't specify it -- it's the default.
	'help'    => \my $help,
	'debug'       => \my $debug
	) or die $USAGE;

if ($help) {
	say STDERR $USAGE;
	say STDERR 'Add a line number to the end of SFM field(s).';
	say STDERR 'The flgmarks option specifies which marker(s) receive the line number';
	say STDERR 'The line number is six digits with leading zeros, preceded by a colon.';
	say STDERR 'If the field has a previous line number, it is replaced with the new number';
	exit;
	}
for ($flgmarks) {
	# remove backslashes and spaces from the SFMs
	say STDERR $_ if $debug;
	$flgmarks =~ s/\\//g;
	$flgmarks =~ s/ //g;
	$flgmarks =~ s/\,*$//; # no trailing commas
	$flgmarks =~ s/\,/\|/g;  # use bars for or'ing
	}
my $srchflgmarks = qr/$flgmarks/;
my $ix;
my $eol;

LINE:
while (<>) {
	$ix = sprintf('%06d', $.);
	if (/^\\$srchflgmarks /) {
		s/(\R)//;
		$eol = $1;
		s/\:[0-9]{6}$//; # remove existing line number
		s/$/:$ix$eol/
		}
	}
continue {
      print or die "-p destination: $!\n";
  }
