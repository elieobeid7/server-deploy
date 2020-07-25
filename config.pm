#!/usr/bin/perl
use strict;
use warnings;

our @repos = (
	{
		repo_path   => "/root/dev/api_repo",
		backup_path => "/var/www/html/backup",
		log_path    => "/var/www/html/logs/",
		branches    => [
			{
                branch_name => "stable",
                copy_to_path => "/var/www/html/",
                log => 1,
                backup=>1.
                delete_files => 0,
                backup_files => [ 
                    "index.php",
                    "assets/css/main.css" 
                ],
                ignore_files => [ 
                    ".gitignore"
                ],
            },
			{ 
                branch_name => "master",
                copy_to_path => "/var/www/html/dev/", 
                backup => 0,
                log => 1,    
                delete_files => 1
            }
		]
	}
);

