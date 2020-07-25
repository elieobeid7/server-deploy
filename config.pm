#!/usr/bin/perl
use strict;
use warnings;

our @repos = (
	{
		repo_path   => "/root/dev/api_repo",

		branches    => [
			{
                branch_name => "stable",
                copy_to_path => "/var/www/html/",
                delete_files => 1,
                ignore_files => [ 
                    ".gitignore"
                ]
            },
			{ 
                branch_name => "master",
                copy_to_path => "/var/www/html/dev/", 
                delete_files => 1
            }
		]
	}
);

