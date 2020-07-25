#!/usr/bin/perl -l
use Cwd;
use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Path qw(make_path);
require "./config.pm";
our (@repos); 

foreach my $repo (@repos) {
     # go to git repo 
    chdir($repo->{repo_path});
    my @branches = $item->{branches}->@*;

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
                    my($filename, $directories, $suffix) = fileparse($git_files[0],qr"\..[^.]*$");
                    my $git_file_path = $directories . $filename . $suffix;
                    
                    if (-e $git_file_path){ 
                        # file was added or modified, check if the file in is ignored or should be copied.
                        if (!$item->{ignore_files} and not grep $_ eq $git_file_path, $item->{ignore_files} ){
                            my $server_dir = $item->{copy_to_path} . $directories;

                        eval { make_path($server_dir) };
                        if ($@) {
                            print "Couldn't create $server_dir: $@";
                        }
                        my $filepath = $directories . $filename . $suffix;
                        copy($filepath, $server_dir) or die "Failed to copy $filepath: $!\n"; 
                        }

            }
                    else if ($delete_files==1) {
                        my $filepath = $directories . $filename . $suffix;
                        unlink $filepath or warn $!;
            }

        }
        }
    }
}




sub backup_and_log {
    my ($backup,$backup_path,$log,$log_path,$filename) = @_;
    if ($backup==1){
        eval { make_path($server_dir) };
        if ($@) {
            print "Couldn't create $server_dir: $@";
            }
            my $filepath = $directories . $filename . $suffix;
            copy($filepath, $server_dir) or die "Failed to copy $filepath: $!\n"; 
            }
    if ($log==1){

    }

}

