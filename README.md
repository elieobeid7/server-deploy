# why use this script?

If you multiple clients, each one has his own server, and you are responsible for maintaining different app for different clients and deploying it on the server, this script comes in handy, especially if sometimes you need to use sftp/ftp to edit some code in a hurry, you won't be able to do git pull directly on the production environment, there will always be some files which don't match your git repo.

I've developed this script to be used at my company, we have multiple clients, each having his own server and have repos, sometimes we need to change things in sftp, so we cannot use git to deploy.

It's written in Perl, because I needed a programming language that would run on any linux server. Perl is installed on all linux servers, this script has no dependencies. 

# How it works

Clone your repo somewhere on the server, outside the production environment, specify the git location and where you want the files to be copied in `DeployModule.pm`. 

That way the files you modified will be pulled from git and copied to the production environment. Make sure that the git repo has the same folder structure as the production environment, so that the path is the same

if you modify `git_repo/css/main.css` it will be copied to `production_environment/css/main.css` 

This script also can, optionally backup some very important files, and log the actions. This option will only work for production environment, there's no need to backup everything, git is a backup tool, you can go back to a previous commit and push. This script will pull it. Or you can stop this script, checkout an old branch on the server get the files you need.

If you want to use the script for multiple projects, make sure that both repos have the same branching model. For example, create branches for all the repos  called `stable` and tell the script to consider `master` and a testing branch and `stable` as development branch for all your repos in `DeployModule.pm`. You should have only one branching model that you'd like to use on all of your projects.

# How to run

Ideally this should be run using a cronjob, but it's up to you.


