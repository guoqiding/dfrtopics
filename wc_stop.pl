#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: wc_stop.pl
#
#        USAGE: ./wc_stop.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Andrew Goldstone (agoldst), andrew.goldstone@gmail.com
# ORGANIZATION: Rutgers University, New Brunswick
#      VERSION: 1.0
#      CREATED: 12/04/2012 07:59:30
#     REVISION: ---
#===============================================================================
use v5.14;                                  # entails strict, unicode_strings 
use autodie;
use utf8;                                   # source code itself is in utf-8
use warnings;
use warnings FATAL => "utf8";               # Unicode encode errors are fatal
use open qw( :std :utf8 );                  # default utf8 layer

my $USAGE = <<EOM;
Usage:
wc_stop -s stoplist_file file1 file2 file3 file4...
EOM

my $first = shift;
unless $first eq "-s" {
    say $USAGE;
    exit;
}
my $stoplist = shift;
open STOP, $stoplist or die;
my %STOPLIST = ();
while(<STOP>) {
    chomp;
    $STOPLIST{$_} = 1; 
}
close STOP;

my $count;
foreach(@ARGV) {
    open my $fh, "$_" or die;
    if(/\.csv$/i) {
        $count = count_csv($fh);
    }
    else {
        $count = count($fh);
    }
    close $fh;
    print "$_,$count\n";
}

sub count_csv {
    my $fh = shift;
    my $header = <$fh>;

    unless($header && $header eq "WORDCOUNTS,WEIGHT\n") {
        die "unexpected header found in csv file";
    }

    my $result = 0;
    while(<$fh>) {
        chomp;
        my ($word,$count) = split /,/;
        $result++ unless $STOPLIST($word);
    }

    return $result;
}

sub count {
    my $fh = shift;
    my $result = 0;
    while(<$fh>) {
        chomp;
        my @words = split;
        foreach(@words) {
            $result++ unless $STOPLIST{$_}; 
        }
    }

    return $result;
}