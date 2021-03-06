#!/usr/bin/perl -l
use Cwd;
use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Path qw(make_path);
require "config.pm";
our (@repos); 

foreach my $repo (@repos) {
    # go to git repo 
    chdir($repo->{repo_path});
    my @branches = @{ $repo->{branches} };

    foreach my $item ( @branches ) {
        # checkout branch and pull
        my $change_branch_command = 'git checkout ' . $item->{branch_name};
        qx{$change_branch_command};
        qx{git stash -u && git reset --hard HEAD};
        my $pull = qx{git pull};
        my @output = split m/\r?\n/, $pull;
        # print $output[0];
        if ($output[0] ne 'Already up-to-date.') {
            my $git_fetch = 'git fetch --all && git reset --hard origin/' . $item->{branch_name};
            qx{$git_fetch};
            # if the repo is not up to date, get the changed files as an array
            my $git_diff = 'git diff --name-only HEAD HEAD~1';
            my $git_dif_head_output = qx{$git_diff};
            my @diff_output = split m/\r?\n/, $git_dif_head_output;
            foreach my $output_line (@diff_output) {
                # remove white spaces
                    $output_line =~ s/\s+//g;

                    #get correct paths
                    my($filename, $directories, $suffix) = fileparse($output_line,qr"\..[^.]*$");
                    my $git_file_path = $directories . $filename . $suffix;
                    
                    if (-e $git_file_path){  
                        if (not grep $_ eq $git_file_path, @{ $item->{ignore_files} || [] }){
                            my $server_dir = $item->{copy_to_path} . $directories;
                            eval { make_path($server_dir) };
                            if ($@) {
                                print "Couldn't create $server_dir: $@";
                                }
                            my  $filepath = $directories . $filename . $suffix;
                            # print "copying to   $filepath . $server_dir";
                            copy($filepath, $server_dir) or die "Failed to copy $filepath: $!\n"; 
                        }

            }
                    elsif ($item->{delete_files}==1) {
                        my $filepath =   $filename . $suffix;
                        my $server_dir = $item->{copy_to_path} . $directories;
                        # print $server_dir . $filepath;
                        unlink $server_dir . $filepath or warn $!;
            }

        }
        }
        #else {
        # print 'branch is up to date';
    # }
    }
}
