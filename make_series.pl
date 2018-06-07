#!/usr/bin/perl
#create a universal header file for the series package

use strict;
use warnings;

#procedures to be included in the package
my @include=qw(series.prc  invert.prc exp.prc log.prc power.prc  Gamma.prc wrap.prc createtable.prc toseries.prc init.prc expand.prc expandDenominator.prc expandLog.prc expandExp.prc expandPower.prc expandGamma.prc expandFunction.prc getCoefficients.prc seriesNormaliseDenominator.prc parallel.prc partition.frm local_series.frm);
#id.prc #multiply.prc #partition.tbl #simplepower.prc contractpowers.prc

#additional data/documentation
my @data=qw(COPYING series_tst.frm doc/series.pdf);


open(OUT,">series.h") or die "Failed to open series.h: $!";

#copyright note
open(IN,'<',"copyright") or die "Failed to open copyright: $!";
print OUT "* $_" while(<IN>);
close IN;

#overall header
my $header='
*Header file for the series package - contains all procedures

#ifndef `SERIESPACKAGE\'
#define SERIESPACKAGE

*global definitions
#ifndef `NAMESPACE\'
#define NAMESPACE ""
#endif
';

print OUT $header;

#add procedures
foreach my $file (@include){
    local $/=undef;
    print "including $file\n";
    open(IN,$file) or die "Failed to open $file: $!";
    $_=<IN>;
    #change to local variables & namespace
    s/\[\:(.*?)\]/[series::$1]/g;
    s/(^|[^\%])\$/$1\$series/g;
    s/\#(procedure|call) /#$1 \`NAMESPACE\'/g;
    print OUT;
}

print OUT  "#endif\n";
chdir("doc") or die "Failed to change directory to 'doc':$!";
system("pdflatex","series.tex")==0 or die "Error executing 'pdflatex series.tex': $!";
chdir("..") or die "Failed to change directory to '..':$!";
system("tar","czf","series.tgz","series.h",@data) == 0
    or die "Error executing 'tar czf series.tgz series.h @data': $!";
