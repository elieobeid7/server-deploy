#!/usr/bin/perl

package Deploy::Module;
use strict;
use warnings;
use Exporter;
our @ISA = 'Exporter';

our @EXPORT = qw(@fileExt, @branches, @repos, @backup, @backup_path, @log, @log_path, @backup_files);
our (@fileExt, @branches, @repos, @backup, @backup_path, @log, @log_path, @backup_files);

# the file extensions you wish to extract from git pull
@fileExt = (".php", ".js", ".html",".css", ".ctp", ".txt", ".log");

# list the branches you want to pull from and where would you want the files to be copied on the server
# indicate if the branch is for production or not. Production repos can be logged and backed up

@branches = ( 
    {
        branch => "master",
        path => "/var/www/html/dev/",
        production => 0, # this is a testing branch
    },
    {
        branch => "stable",
        path => "/var/www/html/",
        production => 1, # this is a production branch
    },
);

# list the locations of the repos on the server
@repos = ("/root/dev/api_repo");

# use log = 0 if you don't want to log the action
@log =1 

# where you want to store the logs
# the logging system is only intended to log production repo actions

@log_path = "/var/www/html/logs/"; 

# use backup=0 if you don't want to backup the original files before new files replace them on git pull
@backup = 1; 

# path of the backup folder
@backup_path = "/var/www/html/backup";

# list the relative file path of the most important files you like to backup, this project isn't meant to backup everything,
# only pick the most important files you like to backup, you can use git the git repo to restore other files
# the backup system is only intended to backup the files in the production repo

@backup_files = ("myproject/index.php");
