Become git ninja

1. [What is GIT?](#what-is-git)
* [Config](#config)
* [Customise your environment](#customise-your-environment)
    * [Your prompt](#customise-your-prompt)
    * [Add custom aliases (for displaying logs)](#add-custom-aliases-for-displaying-logs)
    * [Enable autocompletion](#enable-autocompletion)
* [Under the hood](#under-the-hood)
* [Reference shortcuts (HEAD^^)](#reference-shortcuts)
* [Git file sections](#git-file-sections)
* [What is](#what-is)
    * [Detached HEAD](#detached-head)
* [Commands](#commands)
    * [checkout](#checkout)
* [Rerere](#rerere)
* [Popular use cases](#popular-use-cases)
    * [Create a branch from a previous commit](#create-a-branch-from-a-previous-commit)
* [How to undo things](#how-to-undo-things)
* [Handy commands](#handy-commands)
* [Git workflows](#git-workflows)
* [Prepare your code for commit](#prepare-your-code-for-commit)
* [Great commit messages](#great-commit-messages)
* [Good practices](#good-practices)
* [Do's and don'ts](#dos-and-donts)
* [Aaah moments](#aaah-moments)
* [Scripts](#scripts)
* [Extra facts](#extra-facts)
* [Additional resources](#additional-resources)

# 1. What is GIT?

- git documentation
- git command documentation
`git help branch`
`git help show-ref`

# 2. Config

* `$ git config --local user.email "jakub.kulak@gmail.com"`
* local
* global
* setting aliases

# 3. Customise your environment

1. Copy and paste the snippet of your choice into the configuration file
2. If you are updating your bash configuration file, remember to `$ source ~/.bash_profile` for the changes to take effect

## Customise your prompt

In your bash configuration file (~/.bash_profile in my case):

```bash
# You need to download download the file from:
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

source ~/.git-prompt.sh
PS1='\u, \W $(__git_ps1 "\e[30;42m(%s)\e[m ")\e[0;35m$\e[m '
```

## Add custom aliases (for displaying logs)

In your ~/.gitconfig file:

```bash
[alias]
    ll = log --pretty=oneline --abbrev-commit
    lg = log --pretty=oneline --abbrev-commit --graph --decorate --date=relative
    lgt = log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgtt = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgf = log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative
```

## Enable autocompletion

In your bash configuration file (~/.bash_profile in my case):

```bash
# You need to download download the file from:
# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

source ~/.git-completion.bash
```

# Under the hood

Git data model.

.git/refs/heads

How git stores files (objects directory + graph)
- DAG directed acyclic graph
- hash, 40 characters, sha-1, globally unique
- 4 types of files stored in objects (blob, tree, commit, tag)
- `git cat-file -p d3f732a` to view the commit content
- `git cat-file -t d3f732a` - to check the type of the object
- `git rev-parse df4s` - to display the full hash
- `git rev-parse HEAD~` - to display the full hash

`git show-ref` - see the list of refs
`git show-ref | grep tags` - list tags
`git show-ref | grep heads` - list branches

`git show --pretty=raw HEAD`
`git cat-file -p d3f732a` or HEAD

(Side note: `$ while :; do clear; ls .git/objects -a; sleep 2; done`)

# Reference shortcuts

* HEAD == "the commit I'm currently sitting"
* HEAD^ == "this commit's father"
* HEAD^^ == "this commit's grandfather"
* HEAD^^^ == HEAD~3
* HEAD^^^^^ == HEAD~5
* HEAD~ == HEAD~1 == HEAD^
* master^^ == master~2

# Git file sections

File stages (working trees, staged, committed, pushed)

It's a working tree, because it's a *tree*  and it's your current working area.

Index (old name) = Staging area

# What is

## Detached HEAD

...

## Fast-forward

Fast-forward merge doesn't create extra commit for merging the changes (like GitHub pull request does), and keeps the history linear.

# Commands

## add

* proper way to add files (better than `add .`)
* `$ git add -p` (--patch) - interactive add

## bisect

Run bisect on 1000 commits to find when the line disappeared.

## branch

* `$ git branch -a` - include remote branches
* `$ git branch -v` - verbose, include hashes
* `$ git branch branch_name` - create a branch

## checkout

* checkout with HEAD~4
* `$ git checkout branch_name` - ...
* `$ git checkout -b branch_name` - ...

## cherry-pick

* `$ git cherry-pick hash` - to copy the commit to current branch

## commit

* `$ git commit --amend`

## diff

`git diff --staged` (older alias --cached) staging area <-> HEAD
`git diff HEAD` - workspace <-> HEAD (all changes from the last commit)
`git diff` - workspace <-> staging area

## fetch

* `$ git fetch` - to read the data from origin

## merge 

* `(master) $ git merge feature` - applies all changes on top of master changes and creates a merge commit* (*depends on --no-ff)
* `$ git merge --abort` - cancel the merge 

## rebase

* `(my_feature) $ git rebase master` - applied all changes from master before feature changes

- don't overwrite public history
- only rebase on local branches, before pushing
- `git rebase branch --exec "gulp test"`

1. Rebase branch over master
2. Rebase -i to clean the history

## reflog

Your friend when you are lost (and that can happen often when you are rewriting history).

* `$ git reflog` - to see the list of hashes with the last actions

## reset

* `$ git reset HEAD~` - unstage files, keep working tree (uses --mixed as default)
* `$ git reset --soft HEAD~` - keep files staged, keep working tree
* `$ git reset --hard HEAD~` - unstage files, clear working tree (deletes files)

- git reset --hard to any commit in any branch to move head there

## stash

- stash
- pop
- list

# Rerere

* config rerere.enabled true
* true to reuse recorded resolution (in case there will be many same conflicts while merging)

# Popular use cases

## Create a branch from a previous commit

1. `git checkout HEAD~5` - enter detached head state
2. make some changes
3. `git checkout -b new_branch`

# How to undo things

## Undo last commit
See: [reset](#reset)
...
## Unstage file

* `$ git reset file_name`

## Unstage everything

* `$ git reset`

## Recover deleted file (already staged)

1. `$ git reset -- <file>` - this restores the file status in the staging area
2. `$ git checkout -- <file>` - then check out a copy from the staging area

Use `--` to split commands from parameters

## Recover lost commit

1. `$ git reflog` - to see the list of hashes with last actions
* `$ git checkout hash` - to look around if that's what you need (enters detached HEAD state)
* `$ git checkout my_branch` - to move to the branch you want to fix
* `$ git reset --hard hash` - to move it to the desirable state

# Handy commands

* `$ git checkout -` - checkout last used branch
* `$ git grep keyword` - greps directory returning results with searched keyword, ignores files in your _.gitignore_ by default

# Git workflows

Branching strategies?

https://www.youtube.com/watch?v=to6tIdy5rNc

- merging
- rebasing
- --no-ff
- pull request (GitHub)

# Prepare your code for commit

...

# Great commit messages

...

# Good practices

* When pulling from origin use `$ git pull --rebase` - to put your changes on top of new remote changes

# Do's and don'ts

- don't rebase master?
- don't rewrite published history
- don't force push (`git push -f`) unless you know _exactly_ what you are doing!

# Aaah moments

- branch is simply a text file that contains in plain text the name of the commit it points to -  branch is just a label
- it's not a sequence of commits, but every commit has a parent

# Scripts

Scripts are located in `scripts` directory. Use them to initiate fake repositories to practice git commands.

## create-commits.sh

Creates given number of files with random names, writes 10 lines with random strings to each and creates a commit for each file. Usage: `./create-commits.sh 20`

# Extra facts

* You can merge from multiple branches, and the merge is called octomerge - this is where the GitHub logo (octocat, previously known as not so corporate friendly octopuss) comes from that name.

# Additional resources

- Git under the hood: Advanced Git: Graphs, Hashes, and Compression, Oh My! (https://www.youtube.com/watch?v=ig5E8CcdM9g)