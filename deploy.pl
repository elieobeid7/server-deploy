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
            my $git_dif_head_output =qx{git diff --name-only HEAD^1..HEAD};
            my @diff_output = split m/\r?\n/, $git_dif_head_output;
            foreach my $line (@diff_output) {
                    $line =~ s/\s+//g;
                    my($filename, $directories, $suffix) = fileparse($git_files[0],qr"\..[^.]*$");
                    my $git_file_path = $directories . $filename . $suffix;
                    if (-e $git_file_path){ 
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
 }