#!/usr/bin/perl -l
use Cwd;
use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Path qw(make_path);

use Deploy::Module; 

foreach my $repo (@repos) {
    chdir($repo);

    foreach my $item ( @branches ) {
        my $branch_name = 'git checkout ' . $item->{branch};

        qx{\$branch_name};

        my $pull = qx{git pull};
        my @output = split m/\r?\n/, $pull;
        if ($output[0] ne 'Already up-to-date.') {
            foreach my $line (@output) {
                    $line =~ s/\s+//g;
                    my @git_files = split(/\|/, $line); # get files modified by git, save the info
                    my($filename, $directories, $suffix) = fileparse($git_files[0],qr"\..[^.]*$");
                    if( $suffix ~~ @fileExt ){
                        my $server_dir = $item->{path} . $directories;
                        eval { make_path($server_dir) };
                        if ($@) {
                            print "Couldn't create $server_dir: $@";
                        }
                        my $filepath = $directories . $filename . $suffix;
                        copy($filepath, $server_dir) or die "Failed to copy $filepath: $!\n"; 
                        }
                }
        }
    }
    qx{git checkout master}; # we are done, let's return to the master branch
 }