#!/usr/bin/perl -l
use Cwd;
use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Path qw(make_path);
require "./config.pm";
our (@repos); 
our $filepath;

foreach my $repo (@repos) {
     # go to git repo 
    chdir($repo->{repo_path});
    my @branches = $repo->{branches}->@*;

    foreach my $item ( @branches ) {
        # checkout branch and pull
        my $branch_name = 'git checkout ' . $item->{branch_name};
        qx{\$branch_name};
        my $pull = qx{git pull};

        my @output = split m/\r?\n/, $pull;
        if ($output[0] ne 'Already up-to-date.') {
            
            # if the repo is not up to date, get the changed files as an array

            my $git_dif_head_output =qx{git diff --name-only HEAD^1..HEAD};
            my @diff_output = split m/\r?\n/, $git_dif_head_output;

            foreach my $line (@diff_output) {
                # remove white spaesl
                    $line =~ s/\s+//g;

                    # get correct paths
                    my($filename, $directories, $suffix) = fileparse($line[0],qr"\..[^.]*$");
                    my $git_file_path = $directories . $filename . $suffix;
                    
                    if (-e $git_file_path){ 
                        # file was added or modified, check if the file in is ignored or should be copied.
                        if (!$item->{ignore_files} and not grep $_ eq $git_file_path, $item->{ignore_files} ){
                            my $server_dir = $item->{copy_to_path} . $directories;

                        eval { make_path($server_dir) };
                        if ($@) {
                            print "Couldn't create $server_dir: $@";
                        }
                        $filepath = $directories . $filename . $suffix;
                        copy($filepath, $server_dir) or die "Failed to copy $filepath: $!\n"; 
                        }

            }
                    elsif ($item->{delete_files}==1) {
                        $filepath = $directories . $filename . $suffix;
                        unlink $filepath or warn $!;
            }

        }
        }
    }
}






