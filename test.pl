#!/usr/bin/perl -l
use Cwd;
use strict;
use warnings;
use File::Basename;
use File::Copy;
use Data::Dumper;
use File::Path qw(make_path);
use feature 'say';
require "./config.pm";
our (@repos);


foreach my $item ( @repos ) {
         say $item->{log_path};
	my @branches = $item->{branches}->@*;
    for my $branch ( @branches ) {
        say $branch->{branch_name} 
    }
}

