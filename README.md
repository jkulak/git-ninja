# GIT ninja - foreword

After switching from SVN and using git and GitHub for several years, sometimes panicking when I ended up in a detached HEAD state I decided to really understand the tool that I was using. This README.md file is a collection of most important things that I have learned and that allowed me to become fluent in using git. The most important part, that really opened my eyes is how git works under the hood and is described here: [Under the hood](#under-the-hood).

Since it's not a book, nor a tutorial, I try to keep it short and simple, with some paragraphs being only a list of bullet points with most important/interesting/most used things/commands.

Pull requests are welcome.

Btw. I'm only an aspiring git ninja.

## Your background on git

This README.md file assumes a basic understanding of what git is and how it works generally.

It's beyond the scope of this file to give a full coverage of git, so if you're totally new to git, first go through any of these resources before continuing:

* http://rogerdudler.github.io/git-guide/
* http://tutorialzine.com/2016/06/learn-git-in-30-minutes/
* https://www.sitepoint.com/git-for-beginners/

# TOC

1. [What is GIT?](#1-what-is-git)
* [Config](#2-config)
* [Customise your environment](#3-customise-your-environment)
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

Git describes itself as "git - the stupid content tracker" (from `$ man git`). It means that it doesn't do any magic under the hood - it does exactly what **you** tell it to do.

Apart from many excellent git books and tutorials, you can always `$ man git` to read more about it.

To read about a specific command you can `$ man git show-ref`.

To see a condensed version of the help, with a list of available options for a command, type `$ git reset -h`. Like always, right?

# 2. Config

Git stores it's configuration in three places (for different scopes): system (applied to all users on the system), global (applied to all user's repositories) and local (per project).

* System config is stored in `/etc/gitconfig` and you need admin rights to modify it
* Global config is stored in user's home directory in `~/.gitconfig`.
* Local configs are stored inside your repositories in `project/.git/config`.

Configuration from local config overwrites the global configuration that overwrites the system configuration.

To add/modify configuration settings, you can either edit the files directly, or use git `config` command.

Use `$ git config --global user.email "jakub.kulak@gmail.com"` to add/change e-mail address you want to use with your commits.

Switches `--local` (default), `--global`, `--system` will apply changes to appropriate scope/config file.

## Aliases

Config is where you can define your aliases. Alias is a name for a longer command that you might be using more often.

I like to see my git logs with more details, so instead of writing every time

`$ git log --pretty=oneline --abbrev-commit --graph --decorate --date=relative`

I have defined an alias for that command in my global config file by writing

`$ git config --global alias.lg "log --pretty=oneline --abbrev-commit --graph --decorate --date=relative"`

Now, every time I run `$ git lg` in any of my repositories, I will see the log formatted the way I like it.

Other examples of aliases that I'm using (from my `~/.gitconfig` file)

```bash
[alias]
    ll = log --pretty=oneline --abbrev-commit
    lg = log --pretty=oneline --abbrev-commit --graph --decorate --date=relative
    lgt = log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgtt = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgf = log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative
```

Further aliases I'm using, can be found here: [Custom aliases for displaying logs](#https://github.com/jkulak/my-config-files#add-custom-aliases-for-displaying-logs)

# 3. Customise your environment

If you are working a lot with git in your command line, it makes sense to make it easier and speed it up a little bit by

1. Customising your shell prompt to show you your current branch
2. Enabling auto-complete for git commands (and branch names and others)

## Customise your prompt

First, download the official file from: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh and save it to ~/.git-prompt.sh (or wherever you prefer).

Then, in your bash configuration file (~/.bash_profile in my case) add:

```bash
source ~/.git-prompt.sh
PS1='\u, \W $(__git_ps1 "\e[30;42m(%s)\e[m ")\e[0;35m$\e[m '
```

Remember to `$ source ~/.bash_profile` for the changes to take effect.

Now whenever you navigate to a git repository, you will see additional info in the prompt.

## Enable autocompletion

First, download the official file from: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash and save it to ~/.git-completion.bash (or wherever you prefer).

Then, in your bash configuration file (~/.bash_profile in my case) add:

```bash
source ~/.git-completion.bash
```

Remember to `$ source ~/.bash_profile` for the changes to take effect.

Now, you will be able to use TAB key to auto-complete commands, branch names and others.

# 4. Under the hood

The most important part, that made me understand so many things about git. It's also not as complex as one might think.

## Git data model

Everything git stores, is stored in one of 4 types of objects

* blob: contain file content
* trees: contain directory structure, file names and point to blobs
* commits: contain commit info and point to a tree
* tags: contain tag info and point to a tree

Each object is given a hash identifier (40 characters, SHA-1 hash) that is globally unique (most probably among all repositories in the world).

You can see all the objects in your repository by listing `project/.git/objects`

```bash
jkulak, git-ninja (master) $ tree .git/objects/
.git/objects/
├── 1d
│   ├── 5e36e2b1e6e9959e0c67829c189634efb4dc29
│   └── 8fe4c6c9553e8c14c6cd7892086eafe2aaa9e9
├── 2d
│   └── 827fd2c6cd0b41f12c9326539e58a8d3604e00
├── 3c
│   └── 9dc8e1daa7f979e31682154cc7d2762446afa4
├── 48
│   └── 2c83cf5610cb0d5b1c6b5d35b6a3e810f4af29
├── 50
│   └── fe676d75a0b3239ab9fd99a108bc6f9fb35130
[...]
```

For performance purposes, objects are stored in the directories named with two first characters of their hash, and the rest being the file name of the file.

You know those identifiers from the `$ git log` command that is listing the hashes for commit objects from your repository.

```bash
jkulak, kitchen-lol-slack-bot (master) $ git log --pretty=oneline
0a1707f228fef8287d09271d1e07e8d75669f5ff Optimise provisionig time
8ace349d0ddc0118db0281a30854933c52abe7d8 Use nginx as reverse proxy
2c8696a9e142d1d14a45eef7bbf61d36009d5193 Remove unofficial cookbook dependecies
f893e7376abf416e8d99b8f1d9103aef77ff6f4e Store application in users  directory
7980e3a1de847cc734ec7e0af8d77c5637d83294 Use NFS to mount directories from host
c6c558ae4ec422b9a10bff1ffc73bfc08aa4e225 Install gulp-cli
[...]
```

All objects store by git are compressed by Objects are compressed with zlib, so viewing the file in your editor won't show anything you might be interested in at the moment.

Git offers several low-level commands (also known as plumbing commands - as opposed to porcelain commands - that you are familiar with, like: branch, add, commit, push) to examine stored objects.

Use `$ git cat-file -t d3f732a` to view type of the object (it will be a one of mentioned above four types: blob, tree, commit or tag).

Use `$ git cat-file -p d3f732a` to view the content of the object. For a commit object you will see something like

```bash
tree ba40ec9f2089afbc1b88c49e60814445c4b916b7
parent 7ce3c76716758916cb4177fc3cc88fe685dced5e
author Jakub Kułak <jakub.kulak@gmail.com> 1478149279 -0600
committer Jakub Kułak <jakub.kulak@gmail.com> 1478149279 -0600

Fill README.md with 👍🏻
```

* `tree` points to a tree object for that commit (and that tree will point to all other trees and objects for that commit) - see it for yourself.
* `parent` points to a parent commit for that commit. There might be more than one parent - and then we know it was a merge commit.
* `author` stores information about user that authored the commit.
* `committer` stores the information about the user that committed the changes.
* Last lines contain the commit message.

Check the parent commit content by typing `$ git cat-file -p 7ce3`.

You don't have to use the full hash to access the object. Using first 4 characters is the minimum **if they identify one object**. In most cases, even for big repositories, using 6, 7 first characters is enough.

Another interesting plumbing command is `rev-parse` that will 
expand the given partial hash to a full hash. Try: `$ git rev-parse 7ce3`

## References

https://git-scm.com/book/en/v2/Git-Internals-Git-References


https://en.wikipedia.org/wiki/Directed_acyclic_graph
http://eagain.net/articles/git-for-computer-scientists/

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

## revert

...

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
