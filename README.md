# GIT ninja - foreword

Since I'm only an aspiring git ninja - pull requests are welcome!

After switching from SVN and using git and GitHub for several years, sometimes panicking when I ended up in a detached HEAD state I decided to thoroughly understand the tool I was using. This README.md file is a collection of most important things that I have learned and that allowed me to feel comfortable using git.

The most important part, that really opened my eyes is how git works 🔩 under the hood and I have described it here: [Under the hood](#under-the-hood).

Since it's not a book, nor a tutorial, I try to keep it short and simple, with some chapters being only a list of bullet points with most important/interesting/most used things/commands.

My goal, is that you, after reading this README.md, and finding yourself in a state with a detached head, won't switch to your window file explorer, make a copy of your project, delete it, clone it again from remote and try to see what happened and what are the losses (like I did many times before) - but just handle things like the boss, like the git ninja!

I marked the most important things (and my Oh! moments with the key emoji 🔑 for easy search).

## Your background on git

This README.md file assumes a basic understanding of what git is and how it works generally.

It's beyond the scope of this file to give a full coverage of git, so if you're totally new to git, first go through any of these resources before continuing:

* http://rogerdudler.github.io/git-guide/
* http://tutorialzine.com/2016/06/learn-git-in-30-minutes/
* https://www.sitepoint.com/git-for-beginners/

# TOC

- [What is GIT?](#what-is-git)
- [Config](#config)
  * [Aliases](#aliases)
- [Customise your environment](#customise-your-environment)
  * [Customise your prompt](#customise-your-prompt)
  * [Enable autocompletion](#enable-autocompletion)
- [Under the hood](#under-the-hood)
  * [Git data model](#git-data-model)
- [References](#references)
- [HEAD and heads](#head-and-heads)
- [Reference shortcuts](#reference-shortcuts)
- [Specifying revisions](#specifying-revisions)
- [What is a...](#what-is-a)
  * [Upstream](#upstream)
  * [Git staging area](#git-staging-area)
  * [Working tree](#working-tree)
  * [Detached HEAD](#detached-head)
  * [Fast-forward merge](#fast-forward-merge)
  * [commit-ish (tree-ish)](#commit-ish-tree-ish)
- [Commands](#commands)
  * [add](#add)
  * [bisect](#bisect)
  * [branch](#branch)
  * [checkout](#checkout)
  * [cherry-pick](#cherry-pick)
  * [clean](#clean)
  * [commit [not ready]](#commit--not-ready-)
  * [diff](#diff)
  * [fetch [not ready]](#fetch--not-ready-)
  * [merge [not ready]](#merge--not-ready-)
  * [rebase [not ready]](#rebase--not-ready-)
  * [reflog [not ready]](#reflog--not-ready-)
  * [reset [not ready]](#reset--not-ready-)
  * [revert [not ready]](#revert--not-ready-)
  * [stash [not ready]](#stash--not-ready-)
- [Rerere [not ready]](#rerere--not-ready-)
- [Popular use cases](#popular-use-cases)
  * [How to review one of the previous commits/working trees](#how-to-review-one-of-the-previous-commits-working-trees)
  * [Create a branch from a previous commit [not ready]](#create-a-branch-from-a-previous-commit--not-ready-)
  * [How to rewrite last commit message](#how-to-rewrite-last-commit-message)
- [How to undo things [not ready]](#how-to-undo-things--not-ready-)
  * [Undo last commit [not ready]](#undo-last-commit--not-ready-)
  * [Unstage file [not ready]](#unstage-file--not-ready-)
  * [Unstage everything [not ready]](#unstage-everything--not-ready-)
  * [Recover deleted file (already staged) [not ready]](#recover-deleted-file--already-staged---not-ready-)
  * [Recover lost commit [not ready]](#recover-lost-commit--not-ready-)
- [Handy commands [not ready]](#handy-commands--not-ready-)
- [Git workflows [not ready]](#git-workflows--not-ready-)
- [Prepare your code for commit](#prepare-your-code-for-commit)
- [Great commit messages](#great-commit-messages)
- [Good practices](#good-practices)
- [Do's and don'ts [not ready]](#do-s-and-don-ts--not-ready-)
- [My oh! moments [not ready]](#my-oh--moments--not-ready-)
- [git loglive](#git-loglive)
- [Scripts [not ready]](#scripts--not-ready-)
  * [create-commits.sh](#create-commitssh)
- [Extra facts [not ready]](#extra-facts--not-ready-)
- [Additional resources [not ready]](#additional-resources--not-ready-)

# What is GIT?

Git describes itself as "git - the stupid content tracker" (from `$ man git`). It means that it doesn't do any magic 🔩 under the hood - it does exactly what **you** tell it to do.

Apart from many excellent git books and tutorials, you can always `$ man git` to read more about it.

To read about a specific command you can `$ man git show-ref`.

To see a condensed version of the help, with a list of available options for a command, type `$ git reset -h`. Like always, right?

[🔝 go to table of content](#toc)

# Config

Git stores it's configuration in three places (for different scopes): system (applied to all users on the system), global (applied to all user's repositories) and local (per project).

* System config is stored in `/etc/gitconfig` and you need admin rights to modify it
* Global config is stored in user's home directory in `~/.gitconfig`.
* Local configs are stored inside your repositories in `project/.git/config`.

Configuration from local config overwrites the global configuration that overwrites the system configuration.

To add/modify configuration settings, you can either edit the files directly, or use git `config` command.

Use `$ git config --global user.email "jakub.kulak@gmail.com"` to add/change e-mail address you want to use with your commits.

Switches `--local` (default), `--global`, `--system` will apply changes to appropriate scope/config file.

[🔝 go to table of content](#toc)

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

[🔝 go to table of content](#toc)

# Customise your environment

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

[🔝 go to table of content](#toc)

# Under the hood

The most important part, that made me understand so many things about git. It's also not as complex as one might think.

[🔝 go to table of content](#toc)

## Git data model

[NOTES: https://en.wikipedia.org/wiki/Directed_acyclic_graph
http://eagain.net/articles/git-for-computer-scientists/]

Internally, all files and directories in git project are stored in separate object files in `.git/objects` directory as one of 4 types

* blob: contains file content
* tree: contains directory structure, file names and hashes of blobs (simply, think of it just like a directory listing with files and directories). Top level tree is called a "working tree"
* commit: contains commit info and points to a tree
* tag: contains tag info and points to a tree

A tree with other trees and blobs:

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

[🔝 go to table of content](#toc)

# References

Remembering long hashes is not an easy task - so using them in your daily work would be challenging. This is why w can use references (refs) in git.

References are easy to remember names that point to a commit hash and can be used interchangeably with hashes. 🔩 Under the hood, references are text files that store the 40 character hash that identifies (references) a commit.

You can see those files by listing the `.git/refs` directory. Try `$ find .git/refs`. There is a git plumbing command for that as well: `$ git show-ref` - that will list all references with their corresponding commit hashes.

Some references will point to your branches `$ git show-ref | grep heads` or `$ git show-ref --heads`, other reference tags `$ git show-ref --tags` and other your remote branches and tags `$ git show-ref | grep remote`.

Thanks to references system we can use branch and tag names with git commands, like

* `$ git rev-parse master` - to see the hash of the latest commit in master branch
* `$ git cat-file -p my-branch` - to see the content of the latest commit object in my-branch

[🔝 go to table of content](#toc)

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

[🔝 go to table of content](#toc)

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

Check out https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html (or `$ man girevisions`) to learn more (all EVERYTHING!!!).

[🔝 go to table of content](#toc)

# Specifying revisions

...
@ alone stands for HEAD

[NOTE: https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html]

[🔝 go to table of content](#toc)

# What is a...

## Upstream

Basically upstream for your repository (or branch or tag) is a repository you pull from (you fetched, cloned, etc. from) and/or a repository you push to. This repository can be located on a remote server, but also on your computer in other repository.

Since git is a distributed system - it's important to understand, that there is no absolute upstream (nor downstream) repository - it's all question of the configuration of your repository.

[🔝 go to table of content](#toc)

## Git staging area

Staging area (sometimes an old name "index" is still being used) is a virtual list of objects scheduled for the next commit. It's a snapshot of a working tree that will be used when you perform `commit` command. You can add files to the staging area and remove them from there if needed. Files in the staging area are _staged for the next commit_.

[🔝 go to table of content](#toc)

## Working tree

The working tree means all directories and files in your project in their current state. The top level tree (directory) that points to all directories and files it contains and so on. It is the current state of the files and directories after the last commit and your changes. Working tree can have files that are untracked (new files), staged (after you executed `add` command on them), committed (everything you committed) and pushed.

Files that are staged (added to the next commit), are still a part of the working tree. (🔑)

[🔝 go to table of content](#toc)

## Detached HEAD

Detached HEAD happens, when you move to a place in your repository that is not the latest commit of any of the existing branches.

This can happen, for example, when you execute `$ git checkout cd924da` (or `$ git checkout HEAD~2` - which will switch to the working tree from two commits ago). Simply, when you checkout any commit that is not a head of any existing branch.

🔩 Under the hood, it means that the main HEAD (`.git/HEAD`) is not referencing any of the existing heads in the project (`$ git show-ref --heads`) and therefore is detached 😬.

It's nothing scary, you are not loosing any files nor commits. Read [what to do when you find yourself in the detached head state](#detached-head-state).

[🔝 go to table of content](#toc)

## Fast-forward merge

Fast-forward merge doesn't create an extra commit for merging the changes (like GitHub pull request does), and keeps the history linear. 🔩 Under the hood, it means that the head of the branch that we are merging on to is simply moved to the head of the branch that we are merging from.

[🔝 go to table of content](#toc)

## commit-ish (tree-ish)

...

[🔝 go to table of content](#toc)

# Commands

Git has two types of commands (reflecting the sanitary nomenclature)

1. plumbing - the low-level commands, that can directly manipulate the repository - that you would usually not use in your daily workflow
2. porcelain - the high-level user interface commands that make using git a breeze (kind of 😀).

Most of the commands will accept several universal options, like

*  `-v` (`--verbose`) - make the output more detailed (interesting to see how things work under the hood)
*  `-n` (`--dry-run`) - simulate command run, show the output, but don't make any changes
*  `-f` (`--force`) - potential a dangerous one if you are not 100% what you are doing and how to use it. Always consult a more experience colleague before "forcing" any of the commands on common repositories
*  `-q` (`--quiet`) - quiet mode, surpress feedback (non-error) messages

Often, using a capital letter as an option will mean forcing that option. I.e. `$ git branch -D <branch_name>` is same as `$ git branch -d --force <branch_name>`.

Below I have listed the most popular/useful commands with their most useful usage (and less known tricks/options) in my opinion.

[🔝 go to table of content](#toc)

## add

Adds files from your working tree to the staging area (in other words, makes a snapshot of selected files/changes in your working tree to be used with the next commit).

* `$ git add .` - add all files from the current directory in the working tree to the staging area (stage all files from the working tree). Using `$ git add *` for that purpose skips files that names being with a dot (and usually you don't want to skip those, and if you do - put them in the `.gitignore` file).
* `$ git add -p` (`--patch`) - review every change made in files, and if needed stage only parts of the file. Apart from making sure your changes are what you actually want to commit, it also lets you see if,  by accident, you are not staging any `console.log()` or `var_dump()` statements (if you don't have hooks set up to do it for you).

There are other parameters to tweak the behaviour of `add` command, like `-u` (`--update`) to only add files that area already tracked. To learn more, try `$ man git-add`.

[🔝 go to table of content](#toc)

## bisect

Bisect helps you easily find a commit where a particular change (maybe a bug?) was introduced. It's definitely helpful when working with big repositories with thousands of commits. It simply splits the provided range of commits (can be a whole history), divides it in two, and asks you to confirm if the current commit in the middle contains the change (`$ git bisect bad`) or not (`$ git bisect good`). After your answer, the range is being narrowed down and the step is repeated until you find the commit you are looking for. It's called bisect because it's using [binary search algorithm](https://en.wikipedia.org/wiki/Binary_search_algorithm)

How to perform a bisect search?

1. `$ git bisect start` or `$ git bisect start master 3fff687`
2. `$ git bisect bad` - to mark current commit as bad (you need to set at least one commit as bad - can be an older one - for the search to make sense - otherwise there wouldn't be any bad commits to compare to)
3. `$ git bisect good v1.1.3` - to mark one of the commits (tags) as good, this is optional, if you don't do it, the bisect will start from the very first commit 
4. `$ git bisect next` - to continue the bisect search, git-bisect will switch to the commit in the middle of the range, and will wait for you to perform either `$ git bisect good` - to mark the commit as good, or  `$ git bisect bad` - to mark the commit as bad and to repeat the step 4) until you find the commit that introduced the change you were looking for.

You can automate the testing process by providing the `bisect` command with a shell script that will check if the change is present or not.

You can try bisecting on any repository without worrying about making undesirable changes. When you find yourself lost, just type `$ git bisect reset` to leave the bisecting mode and return where you started.

To perform a test `bisect`, you can clone the `npm/npm` repository from GitHub (for example) and using the `scripts/bisect-test.sh` script from this repository check when the given file was created.

```bash
# copy the bisect-text.sh script to the working tree
$ git bisect start master e790c85a061
$ git bisect run ./bisect-test.sh
```

And after couple of seconds, you will get

```bash
jkulak, npm ((3fff687...)|BISECTING) $ git bisect run ./bisect-test.sh
running ./bisect-test.sh
[...]
Running the bisect testing script...
✅ File not found!
0019443e4b4e19b3213ac1edf14b8f483e86583d is the first bad commit
```

And now you know, that the commit `0019443` was when the file was added to the repository.

[🔝 go to table of content](#toc)

## branch

Git `branch` can work with single branch or all branches - depending if you supply a branch name as an argument.

The most popular uses, without giving it a particular branch are

* `$ git branch` - to list all the existing branches
* `$ git branch -a` - will include remote branches (`-r` shows only remote-tracking branches)
* `$ git branch -v` - gives (like always) more verbose output - here it includes the hashes and commit messages

The most popular, branch specific uses include

* `$ git branch <new_branch_name>` - create a branch. This command will not switch  to the new branch. To create a new branch and switch to it (check it out), use `$ git checkout -b <new_branch_name>`)
* `$ git branch -d <branch_name>` - deletes the branch from the local repository (but if it existed in the remote directory - it will still exist there, and you will be able to pull it). To delete from a remote location, use `$ git push origin --delete <branch_name>` (a shortcut for that, using a colon syntax, is `$ git push origin :<branch_name>`). In case the branch has changes, and was not merged, you will see an error message, and to force the deletion, you will have to use `-D` option.
* `$ git branch -m <new_branch_name>` - rename your current branch to <new_branch_name> (and the corresponding reflog)

[🔝 go to table of content](#toc)

## checkout

Git checkout, does two things; either switches between branches, or checks out a file (or a tree) from the history. 

To checkout means to take the version of the file or directory (tree), or the whole working tree (all your files) from a given revision from your repository.

Checking out a whole working tree (i.e. a previous commit), like `$ git checkout  551c3e0` would lead to a [detached head state](#detached-head).

* `$ git checkout <branch_name>` - switch to an existing `<branch_name>`. Using the `-b` option will create new branch before checking it out. That is git 101.
* `$ git checkout master~3 <file_name>` - update <file_name> with a version from master~3 (this can be any revision, where the file <file_name> existed). If no revision is supplied, git will try to checkout the file from the latest tree/commit. You can use this after accidentally deleting a file from a working tree.

[🔝 go to table of content](#toc)

## cherry-pick

Git `cherry-pick` is used to apply commits from another branch onto the current one. It's often used when you commit something to a wrong branch, and you want to move it to a proper one. It doesn't move the commits, it creates the new commit, with a new sha-1.

* `$ git cherry-pick <revision>` - to copy the commit to current branch. If you want to get rid of the commit from the source branch, see [reset](#reset)

See the full entry for [cherry-pick](https://www.kernel.org/pub/software/scm/git/docs/git-cherry-pick.html) in the The Linux man-pages project.

[🔝 go to table of content](#toc)

## clean

Git `clean` removes untracked files from the repository.

It comes in handy, when you, for example, unzip an archive in your working tree with many files. Git `clean` does not remove directories by default. To remove also untracked directories, add `-d` option.

`$ git clean -i -d` - `-i` stars for interactive, and the command will lead you through the rest of the process.

Remember that you can use it inside on of the directories in the repository, not necessarily in the root directory of the repository.

As with most of the git commands, you can use `-n` option to only dry-run the process to see what is there to be removed - recommended!

[🔝 go to table of content](#toc)

## commit [not ready]

* `$ git commit --amend`

[🔝 go to table of content](#toc)

## diff

Git `diff` shows the differences/changes between commits, tags, staging area and working tree. In the regular daily workflow of a developer, those three variants are most useful

* `$ git diff` - without any parameters, it will show the changes between the working tree and the staging area (all changes you have introduced after last git `add` command).
* `$ git diff --staged` - (previous option name `--cached`) shows changes between the staging area (staged for the next commit) and the last last commit (current `HEAD`), it doesn't show any changes you introduced after your last git `add` command.
* `$ git diff HEAD` - shows all changed introduced after last commit. In other words, it shows all changes between the working tree (either staged or not) and the current `HEAD`.

It is possible to compare two commits, by running `diff` with their hashes: `$ git diff 9664c64 e748eab` or using the revision shortcuts like: `$ git diff HEAD~11 HEAD`.

To get a summary of file changes, use the `--raw` option.

`$ git diff master~8 master --raw` that will result in a similar (kind of) output, showing which files have been added/modified/deleted

```
:100644 100644 9bae3ce... 1860be7... M  Dockerfile
:000000 100644 0000000... 2ce4f19... A  README.md
:100644 100644 d90a5e7... 9e68223... M  index.js
:000000 100644 0000000... 4e13ce8... A  lib/server.js
:100644 100644 a0257a7... e991f95... M  process.json
:100755 100755 07ce281... 8036a21... M  scripts/docker-deploy.sh
:100644 100644 9ae55d6... 914fc83... M  web/app.js
:100644 100644 27b76b7... 53f40f4... M  web/index.html
:100644 100644 67d73af... 08a1bb4... M  web/main.css
```

[🔝 go to table of content](#toc)

## fetch [not ready]

* `$ git fetch` - to read the data from origin

[🔝 go to table of content](#toc)

## merge [not ready]

* `(master) $ git merge feature` - applies all changes on top of master changes and creates a merge commit* (*depends on --no-ff)
* `$ git merge --abort` - cancel the merge

[🔝 go to table of content](#toc)

## rebase [not ready]

* `(my_feature) $ git rebase master` - applied all changes from master before feature changes

- don't overwrite public history
- only rebase on local branches, before pushing
- `git rebase branch --exec "gulp test"`

1. Rebase branch over master
2. Rebase -i to clean the history

[🔝 go to table of content](#toc)

## reflog [not ready]

Reflog is your friend when you are lost (and that can happen often when you are rewriting history).

* `$ git reflog` - to see the list of hashes with the last actions

[🔝 go to table of content](#toc)

## reset [not ready]

git reset -p

* `$ git reset HEAD~` - unstage files, keep working tree (uses --mixed as default)
* `$ git reset --soft HEAD~` - keep files staged, keep working tree
* `$ git reset --hard HEAD~` - unstage files, clear working tree (deletes files)

- git reset --hard to any commit in any branch to move head there

[🔝 go to table of content](#toc)

## revert [not ready]

...

[🔝 go to table of content](#toc)

## stash [not ready]

- stash
- pop
- list

[🔝 go to table of content](#toc)

# Rerere [not ready]

* config rerere.enabled true
* true to reuse recorded resolution (in case there will be many same conflicts while merging)

[🔝 go to table of content](#toc)

# Popular use cases

## How to review one of the previous commits/working trees

Assuming you are on a `branch_name` branch.

1. `$ git log` - or your favourite log command to find a revision that you are interested in and copy its hash 
* `$ git stash` - to stash all current, uncommitted changes
* `$ git checkout <revision>` - this updates the working tree with version from the selected revision and puts you in the [detached head state](#detached-head)
* Look around, review what you wanted
* `$ git checkout branch_name` - to return to the latest version of your branch
* `$ git stash pop` - to bring your uncommitted changes back

[🔝 go to table of content](#toc)

## Create a branch from a previous commit [not ready]

1. `git checkout HEAD~5` - enter detached head state
2. make some changes
3. `git checkout -b new_branch`

[🔝 go to table of content](#toc)

## How to rewrite last commit message

[🔝 go to table of content](#toc)

# How to undo things [not ready]

## Undo last commit [not ready]
See: [reset](#reset)

[🔝 go to table of content](#toc)

## Unstage file [not ready]

* `$ git reset file_name`

[🔝 go to table of content](#toc)

## Unstage everything [not ready]

* `$ git reset`

[🔝 go to table of content](#toc)

## Recover deleted file (already staged) [not ready]

1. `$ git reset -- <file>` - this restores the file status in the staging area
2. `$ git checkout -- <file>` - then check out a copy from the staging area

Use `--` to split commands from parameters

[🔝 go to table of content](#toc)

## Recover lost commit [not ready]

1. `$ git reflog` - to see the list of hashes with last actions
* `$ git checkout hash` - to look around if that's what you need (enters detached HEAD state)
* `$ git checkout my_branch` - to move to the branch you want to fix
* `$ git reset --hard hash` - to move it to the desirable state

[🔝 go to table of content](#toc)

# Handy commands [not ready]

* `$ git checkout -` - checkout last used branch
* `$ git grep keyword` - greps directory returning results with searched keyword, ignores files in your `.gitignore` by default
* `$ git shortlog -sne` - show number of commits per person with their e-mail address

[🔝 go to table of content](#toc)

# Git workflows [not ready]

Branching strategies?

https://www.youtube.com/watch?v=to6tIdy5rNc
https://sandofsky.com/blog/git-workflow.html
http://nvie.com/posts/a-successful-git-branching-model/

- merging
- rebasing
- --no-ff
- pull request (GitHub)

[🔝 go to table of content](#toc)

# Prepare your code for commit

It's a good practice to follow several rules to make your code meet the project standards and not cause unnecessary confusion in the repository.

Basically -- remove any excessive whitespace and empty lines from your files -- so that they don't appear as changes in your code.

* remove all trailing whitespace from empty lines
* merge consecutive empty lines into one
* make sure last line has an end line character — because every line should have an end line character (so e.g. we don't see those ugly, red arrow characters in GitHub)

Of course your preferences may vary, so those are just suggestions.

Best if you make your favourite code editor take care of all those points (all the most popular code editors have you covered check out Atom or Sublime Text).

I found it a good solution to have a `.editorconfig` file in your repository (http://editorconfig.org/) that is shared with other contributors, that fixes the crucial configuration for your editors (and is supported by most of the popular editors). An example of a `.editorconfig` file: [https://github.com/babel/babel/blob/master/.editorconfig](https://github.com/babel/babel/blob/master/.editorconfig)

[🔝 go to table of content](#toc)

# Great commit messages

Commit messages should be descriptive and clear. E.g. in case you need to roll back changes from production quickly — you want to be able to quickly understand up to which commit you want to roll back.

How often do you see commit messages like

* `Now added delete for real`
* `Sometimes when split cookie, cookie not want get split. Make sure cookie edible before bite! OOMMNOMNOMnoMnoMNoMNOmNOMoNMNOM!!!!` - this one is actually taken from npm's repository 😬
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

Remember that before pushing to your remote, you can also rewrite your commit messages (see `--amend` switch in [commit](#commit) section) and in case of redundant commits (like `Fix typo`) you can squash them into one (see [rebase](#rebase)).

[🔝 go to table of content](#toc)

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

[🔝 go to table of content](#toc)

# Do's and don'ts [not ready]
- don't rebase master?
- don't rewrite published history
- don't force push (`git push -f`) unless you know _exactly_ what you are doing!

[🔝 go to table of content](#toc)

# My oh! moments [not ready]

* branch is simply a text file that contains in plain text the name of the commit it points to -  branch is just a label

[🔝 go to table of content](#toc)

# git loglive

For testing and learning purposes, it might help, when you can see the history of your repository live, when you are making the changes. See the git loglive script in action

![How to use git loglive script](https://raw.githubusercontent.com/jkulak/git-ninja/master/resources/git-loglive.gif "git loglive in action")

The script is available here: https://gist.github.com/jkulak/9d188fb51e4ea1821b2bb5f748a57b64

[🔝 go to table of content](#toc)

# Scripts [not ready]

Scripts are located in `scripts` directory. Use them to initiate fake repositories to practice git commands.

[🔝 go to table of content](#toc)

## create-commits.sh

Creates given number of files with random names, writes 10 lines with random strings to each and creates a commit for each file. Usage: `./create-commits.sh 20`

[🔝 go to table of content](#toc)

# Extra facts [not ready]

* You can merge from multiple branches, and the merge is called octomerge - this is where the GitHub logo (octocat, previously known as, not so corporate friendly, octopuss) comes from that name.

[🔝 go to table of content](#toc)

# Additional resources [not ready]

* Git under the hood: Advanced Git: Graphs, Hashes, and Compression, Oh My! (https://www.youtube.com/watch?v=ig5E8CcdM9g)
* List of very handy aliases to make your work with git easier, faster and at times more secure: https://hackernoon.com/lesser-known-git-commands-151a1918a60
* Specifying git revisions (from `$ man girevisions`): https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html 

[🔝 go to table of content](#toc)

# My notes - won't be here in the final version

* alias.m = "checkout master"
* (Side note: `$ while :; do clear; ls .git/objects -a; sleep 2; done`)

- DAG directed acyclic graph
- hash, 40 characters, sha-1, globally unique
- 4 types of files stored in objects (blob, tree, commit, tag)
- `git cat-file -p d3f732a` to view the commit content
- `git cat-file -t d3f732a` - to check the type of the object
- `git rev-parse df4s` - to display the full hash
- `git rev-parse HEAD~` - to display the full hash

`git show --pretty=raw HEAD`
`git cat-file -p d3f732a` or HEAD