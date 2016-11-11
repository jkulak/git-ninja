# GIT ninja - foreword

Since I'm only an aspiring git ninja - pull requests are welcome!

After switching from SVN and using git and GitHub for several years, sometimes panicking when I ended up in a detached HEAD state I decided to thoroughly understand the tool I was using. This README.md file is a collection of most important things that I have learned and that allowed me to feel comfortable using git.

The most important part, that really opened my eyes is how git works 🔩 under the hood and I have described it here: [Under the hood](#under-the-hood).

Since it's not a book, nor a tutorial, I try to keep it short and simple, with some chapters being only a list of bullet points with most important/interesting/most used things/commands.

I marked the most important things (and my Oh! moments with the key emoji 🔑 for easy search).

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
* [References](#references)
* [HEAD and heads](#head-and-heads)
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

Git describes itself as "git - the stupid content tracker" (from `$ man git`). It means that it doesn't do any magic 🔩 under the hood - it does exactly what **you** tell it to do.

Apart from many excellent git books and tutorials, you can always `$ man git` to read more about it.

To read about a specific command you can `$ man git show-ref`.

To see a condensed version of the help, with a list of available options for a command, type `$ git reset -h`. Like always, right?

[🔝 go to table of content](#toc)

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

1. customising your shell prompt to show you your current branch,
2. enabling auto-complete for git commands (and branch names and others).

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

[NOTES: https://en.wikipedia.org/wiki/Directed_acyclic_graph
http://eagain.net/articles/git-for-computer-scientists/]

Internally, all files and directories in git project are stored in separate object files in `.git/objects` directory as one of 4 types

* blob: contains file content
* tree: contains directory structure, file names and hashes of blobs (simply, think of it just like a directory listing with files and directories). Top level tree is called a "working tree"
* commit: contains commit info and points to a tree
* tag: contains tag info and points to a tree

Tree with trees and blobs:

```bash
. (tree)
├── Dockerfile (blob)
├── README.md (blob)
├── app.js (blob)
├── dist (tree)
│   └── assets (tree)
│       ├── css (tree)
│       │   ├── main.css (blob)
│       │   └── main.min.css (blob)
│       └── img (tree)
│           └── lol-logo.png (blob)
├── favicon.ico (blob)
├── gulpfile.js (blob)
├── lib (tree)
│   ├── config (tree)
│   │   ├── config.js (blob)
│   │   └── config.js.example (blob)
[...]
```

Each object is given a hash identifier (40 characters, SHA-1 hash) that is globally unique (most probably among all repositories in the world).

That's why sometimes git is referred to as "a content-addressable file system with a VCS user interface written on top of it."

You can see all the objects in your repository by listing `.git/objects` directory.

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

For performance purposes, objects are stored in the directories named with two first characters of their hash, and the rest being the filename of the file.

You know those hash identifiers from the `$ git log` command that is listing the hashes for commit objects from your repository.

```bash
jkulak, kitchen-lol-slack-bot (dockerize) $ git log --pretty=oneline
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

Fill README.md with 👍🏻 and ❤️
```

* `tree` points to a tree object for that commit (and that tree will point to all other trees and objects for that commit).
* `parent` points to a parent commit for that commit. There might be more than one parent - and then we know it was a merge commit.
* `author` stores information about user that authored the commit.
* `committer` stores the information about the user that committed the changes.
* Last lines contain the commit message.

Check the parent commit content by typing `$ git cat-file -p 7ce3`.

As you see, you don't have to use the full hash to access the object. Using first 4 characters is the minimum **if they unambiguously identify an object**. Most git commands show the hash shortened to 7 characters - so I assume that's the safe length for most repositories.

Commit always points to one tree (🔑).

Another interesting plumbing command is `rev-parse` that will expand the given partial hash (or a reference - please see the next chapter) to a full hash. Try: `$ git rev-parse 7ce3` to see how it works (use a hash that exists in your repository).

# References

Remembering long hashes is not an easy task - so using them in your daily work would be challenging. This is why w can use references (refs) in git.

References are easy to remember names that point to a commit hash and can be used interchangeably with hashes. 🔩 Under the hood, references are text files that store the 40 character hash that identifies (references) a commit.

You can see those files by listing the `.git/refs` directory. Try `$ find .git/refs`. There is a git plumbing command for that as well: `$ git show-ref` - that will list all references with their corresponding commit hashes.

Some references will point to your branches `$ git show-ref | grep heads` or `$ git show-ref --heads`, other reference tags `$ git show-ref --tags` and other your remote branches and tags `$ git show-ref | grep remote`.

Thanks to references system we can use branch and tag names with git commands, like

* `$ git rev-parse master` - to see the hash of the latest commit in master branch
* `$ git cat-file -p my-branch` - to see the content of the latest commit object in my-branch

# HEAD and heads

HEAD is a reference to the latest commit in currently checked out branch[*]. HEAD is stored in `.git/HEAD` file, view that file's content to see what does it reference. There is/can be only one HEAD at a time!

[*] - there is an exception to that, please check the [detached head](#detached-head) chapter.

When you list `.git/refs/heads` directory, or run `$ git show-ref --heads` you might see several entries

```bash
jkulak, inr-api (new-school-deployment) $ git show-ref --heads
f88023944e7059f4636dd68fd819b514f4819fda refs/heads/develop
0396959e8e2be4ef255f274589f862755d90cab1 refs/heads/master
4663e74ce653141d27b9ba92d17f9d9299c91393 refs/heads/new-school-deployment
```

Those are the heads that are available, and actually, those are the branches that are available in your local repository!

You will get a similar output after running `$ git branch -v`.

While on `new-school-deployment` branch, run `$ git checkout develop` to switch to `develop` branch. 🔩 Under the hood it means updating content of `.git/HEAD` file, by changing it's content from `ref: refs/heads/new-school-deployment` to `ref: refs/heads/develop` - now your HEAD points to `refs/heads/develop` which contains hash of the latest commit of `develop` branch. 😃

# Reference shortcuts

You might have seen things like `HEAD^`, `HEAD~4` and `master^^`.

Each commit has a parent (or more parents in case it's a merge). To reference the parent commit, you can use `^` or `~` syntax. 

* HEAD == the commit I'm currently sitting in
* HEAD^ == this commit's father
* HEAD^^ == this commit's grandfather
* HEAD^ == HEAD~1 == HEAD~ (🔑)
* HEAD^^^^^ == HEAD~5
* master^ == master~
* some-tag^^ == some-tag~2
* some-branch^^^ == some-branch~3

# What is a...

## Git staging area

Staging area (sometimes an old name "index" is still being used) is a virtual list of objects scheduled for the next commit. You can add files to the staging area and remove them from there if needed. Files in the staging area are _staged for the next commit_.

## Working tree

The working tree means all directories and files in your project in their current state. The top level tree (directory) that points to all directories and files it contains and so on. It is the current state of the files and directories after the last commit and your changes. Working tree can have files that are untracked (new files), staged (after you executed `add` command on them), committed (everything you committed) and pushed.

Files that are staged (added to the next commit), are still a part of your working tree. (🔑)

## Detached HEAD

Detached HEAD happens, when you move to a place in your repository that is not the latest commit of any of the existing branches.

This can happen, for example, when you execute `$ git checkout cd924da` (or `$ git checkout HEAD~2` - which will switch to your working tree from two commits ago). Simply, when you checkout any commit that is not a head of any existing branch.

🔩 Under the hood, it means that the main HEAD (`.git/HEAD`) is not referencing any of the existing heads in the project (`$ git show-ref --heads`) and therefore is detached 😬.

It's nothing scary, you are not loosing any files nor commits. Read [what to do when you find yourself in the detached head state](#detached-head-state).

## Fast-forward merge

Fast-forward merge doesn't create an extra commit for merging the changes (like GitHub pull request does), and keeps the history linear. 🔩 Under the hood, it means that the head of the branch that we are merging on to is simply moved to the head of the branch that we are merging from.

# Commands

Git has two types of commands (reflecting the sanitary nomenclature)

1. plumbing - the low-level commands, that can directly manipulate the repository - that you would usually not use in your daily workflow
2. porcelain - the high-level user interface commands that make using git a breeze (kind of 😀).

Below I have listed the most popular/useful commands with their most useful usage (and less known tricks/options) in my opinion.

## add [not ready]

* proper way to add files (better than `add .`)
* `$ git add -p` (--patch) - interactive add

## bisect [not ready]

Run bisect on 1000 commits to find when the line disappeared.

## branch [not ready]

* `$ git branch -a` - include remote branches
* `$ git branch -v` - verbose, include hashes
* `$ git branch branch_name` - create a branch

## checkout [not ready]

* checkout with HEAD~4
* `$ git checkout branch_name` - ...
* `$ git checkout -b branch_name` - ...

## cherry-pick [not ready]

* `$ git cherry-pick hash` - to copy the commit to current branch

## commit [not ready]

* `$ git commit --amend`

## diff [not ready]

`git diff --staged` (older alias --cached) staging area <-> HEAD
`git diff HEAD` - work tree <-> HEAD (all changes from the last commit)
`git diff` - work tree <-> staging area

## fetch [not ready]

* `$ git fetch` - to read the data from origin

## merge [not ready]

* `(master) $ git merge feature` - applies all changes on top of master changes and creates a merge commit* (*depends on --no-ff)
* `$ git merge --abort` - cancel the merge

## rebase [not ready]

* `(my_feature) $ git rebase master` - applied all changes from master before feature changes

- don't overwrite public history
- only rebase on local branches, before pushing
- `git rebase branch --exec "gulp test"`

1. Rebase branch over master
2. Rebase -i to clean the history

## reflog [not ready]

Reflog is your friend when you are lost (and that can happen often when you are rewriting history).

* `$ git reflog` - to see the list of hashes with the last actions

## reset [not ready]

* `$ git reset HEAD~` - unstage files, keep working tree (uses --mixed as default)
* `$ git reset --soft HEAD~` - keep files staged, keep working tree
* `$ git reset --hard HEAD~` - unstage files, clear working tree (deletes files)

- git reset --hard to any commit in any branch to move head there

## revert [not ready]

...

## stash [not ready]

- stash
- pop
- list

# Rerere [not ready]

* config rerere.enabled true
* true to reuse recorded resolution (in case there will be many same conflicts while merging)

# Popular use cases [not ready]

## Create a branch from a previous commit [not ready]

1. `git checkout HEAD~5` - enter detached head state
2. make some changes
3. `git checkout -b new_branch`

# How to undo things [not ready]

## Undo last commit [not ready]
See: [reset](#reset)
...
## Unstage file [not ready]

* `$ git reset file_name`

## Unstage everything [not ready]

* `$ git reset`

## Recover deleted file (already staged) [not ready]

1. `$ git reset -- <file>` - this restores the file status in the staging area
2. `$ git checkout -- <file>` - then check out a copy from the staging area

Use `--` to split commands from parameters

## Recover lost commit [not ready]

1. `$ git reflog` - to see the list of hashes with last actions
* `$ git checkout hash` - to look around if that's what you need (enters detached HEAD state)
* `$ git checkout my_branch` - to move to the branch you want to fix
* `$ git reset --hard hash` - to move it to the desirable state

# Handy commands [not ready]

* `$ git checkout -` - checkout last used branch
* `$ git grep keyword` - greps directory returning results with searched keyword, ignores files in your `.gitignore` by default
* `$ git shortlog -sne` - show number of commits per person with their e-mail address

# Git workflows [not ready]

Branching strategies?

https://www.youtube.com/watch?v=to6tIdy5rNc

branching model: http://nvie.com/posts/a-successful-git-branching-model/ and adjust to your organisation/environment

- merging
- rebasing
- --no-ff
- pull request (GitHub)

# Prepare your code for commit

It's a good practice to follow several rules to make your code meet the project standards and not cause unnecessary confusion in the repository.

Basically -- remove any excessive whitespace and empty lines from your files -- so that they don't appear as changes in your code.

* remove all trailing whitespace from empty lines
* merge consecutive empty lines into one
* make sure last line has an end line character — because every line should have an end line character (so e.g. we don't see those ugly, red arrow characters in GitHub)

Of course your preferences may vary, so those are just suggestions.

Best if you make your favourite code editor take care of all those points (all the most popular code editors have you covered check out Atom or Sublime Text).

I found it a good solution to have a `.editorconfig` file in your repository (http://editorconfig.org/) that is shared with other contributors, that fixes the crucial configuration for your editors (and is supported by most of the popular editors). An example of a `.editorconfig` file: [https://github.com/babel/babel/blob/master/.editorconfig](https://github.com/babel/babel/blob/master/.editorconfig)

# Great commit messages

Commit messages should be descriptive and clear. E.g. in case you need to roll back changes from production quickly — you want to be able to quickly understand up to which commit you want to roll back.

How often do you see commit messages like

* `Now added delete for real`
* `Committed some changes`
* `Fixed typo, last commit for today`

I would not know if it's ready to be deployed or not, and what were the exact changes (without carefully studying the diff).

To make it easier for everyone and keep your commit history clean, in your commit messages

* state clearly what has been changed, start your commit messages with a verb in present tense in an imperative form: Add..., Fix..., Remove..., Make..., Configure... (messages like “Advertisement code for category pages” — don't tell us if it was removed, added or modified — so the message is useless)
* make your commit message 50 or less characters long
* don't put period at the end (it's a title and you don't put periods at the end of the titles)
* if your commit message brings extra "why?" question in mind, add extra details in the commit description, by pointing them out
* you can point out some technical details in the description if it's necessary
* if you are working with a ticketing system, add the ticket ID in the beginning of commit message so it integrates nicely with your software (e.g. Jira, Confluence) — this depends on your organisation — so discuss it internally!

Go to [http://whatthecommit.com/](http://whatthecommit.com/) and don't use it as an inspiration! 😁

Remember that before pushing to your remote, you can also rewrite your commit messages (see `--amend` switch in [commit](#commit) section) and in case of redundant commits (like `Fix typo`) you can squash them into one (see [rebase](#rabse)).

# Good practices

Your cooperation model depends heavily on your organisation, so it discuss internally, and don't apply any guidelines and good practices blindly.

* For all changes you want to make, create a separate branch (new feature, bug fix, removing old feature)
* Squash excessive commits to keep repository's history clean (before pushing your branch make sure there are no unnecessary commits like: `Fix the title typo` or `Forgot to add the dependency`). See the [Great commit messages](#great-commit-messages) chapter.
* When working with GitHub (GitLab, etc.), use Pull requests or rebase to merge your changes (depending on your working model) into desired branch
* Don't commit changes not related to you current task/feature (do it rather in a separate branch)
* Don't commit any debug/test code (`var_dump()`, `console.log()`, etc.) — you could automate this, by setting up a pre-commit hook
* Stick to coding standards defined for your project... obviously (tabs or spaces, function names, etc.)
* Have linting implemented in your workflow (with shared/common configuration among your team)
* When pulling from origin use `$ git pull --rebase` - to put your changes on top of new remote changes

# Do's and don'ts [not ready]

- don't rebase master?
- don't rewrite published history
- don't force push (`git push -f`) unless you know _exactly_ what you are doing!

# My oh! moments [not ready]

* branch is simply a text file that contains in plain text the name of the commit it points to -  branch is just a label

# Scripts [not ready]

Scripts are located in `scripts` directory. Use them to initiate fake repositories to practice git commands.

## create-commits.sh

Creates given number of files with random names, writes 10 lines with random strings to each and creates a commit for each file. Usage: `./create-commits.sh 20`

# Extra facts [not ready]

* You can merge from multiple branches, and the merge is called octomerge - this is where the GitHub logo (octocat, previously known as not so corporate friendly octopuss) comes from that name.

# Additional resources [not ready]

- Git under the hood: Advanced Git: Graphs, Hashes, and Compression, Oh My! (https://www.youtube.com/watch?v=ig5E8CcdM9g)

==============================================================
= NOTES 
==============================================================

How git stores files (objects directory + graph)
- DAG directed acyclic graph
- hash, 40 characters, sha-1, globally unique
- 4 types of files stored in objects (blob, tree, commit, tag)
- `git cat-file -p d3f732a` to view the commit content
- `git cat-file -t d3f732a` - to check the type of the object
- `git rev-parse df4s` - to display the full hash
- `git rev-parse HEAD~` - to display the full hash

`git show --pretty=raw HEAD`
`git cat-file -p d3f732a` or HEAD

(Side note: `$ while :; do clear; ls .git/objects -a; sleep 2; done`)
