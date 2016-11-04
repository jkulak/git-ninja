# Become git ninja

* [Usage](#usage)
* [BASH](#bash)
    * [Customise your prompt](#customise-your-prompt)
* [GIT](#git)
    * [Add custom aliases (for displaying logs)](#add-custom-aliases-for-displaying-logs)
    * [Enable autocompletion](#enable-autocompletion)
* [Scripts](#scripts)

## Usage

1. Copy and paste the snippet of your choice into the configuration file
2. If you are updating your bash configuration file, remember to `$ source ~/.bash_profile` for the changes to take effect

## BASH

### Customise your prompt

In your bash configuration file (~/.bash_profile in my case):

```bash
# You need to download download the file from:
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

source ~/.git-prompt.sh
PS1='\u, \W $(__git_ps1 "\e[30;42m(%s)\e[m ")\e[0;35m$\e[m '
```

## GIT

### Add custom aliases (for displaying logs)

In your ~/.gitconfig file:

```bash
[alias]
    ll = log --pretty=oneline --abbrev-commit
    lg = log --pretty=oneline --abbrev-commit --graph --decorate --date=relative
    lgt = log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgtt = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
    lgf = log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative
```

### Enable autocompletion

In your bash configuration file (~/.bash_profile in my case):

```bash
# You need to download download the file from:
# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

source ~/.git-completion.bash
```

## Scripts

Scripts are located in `scripts` directory. Use them to initiate fake repositories to practice git commands.

### create-commits.sh

Creates given number of files with random names, writes 10 lines with random strings to each and creates a commit for each file. Usage: `./create-commits.sh 20`

0. What is GIT?
- git documentation
- git command documentation
`git help branch`
`git help show-ref`

1. Prepare your environment
    1. Shell prompt
    2. Config  
    - local
    - global
    - aliases

3. My ahaaa moments
- what are branches
- same with tags


4. How git stores files (objects directory + graph)
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


5. HEAD^^^ == HEAD~3 (HEAD~ == HEAD~1 == HEAD^)
- master^^ == master~2
6. File stages (working trees, staged, committed, pushed)

It's a working tree, because it's a *tree*  and it's your current working area.

Index (old name) = Staging area
...
...
7. Commands

## checkout
- checkout with HEAD~4

6. rerere.enabled true
6. Popular uses cases
- `git checkout HEAD~5` - enter detached head state
make some changes  
`git checkout -b new_branch`
- ...
7. How to undo things

8. Handy commands
* `$ git checkout -` - checkout last used branch
* `$ git grep keyword` - greps directory returning results with searched keyword, ignores files in your .gitignore by default

9. Different workflows
- merging, rebasing, --no-ff
10. Prepare your code
- 
11. Great commit messages
12. Good practices
12. Git dos and donts
- don't rebase master
- don't rewrite published history
- don't force push (`git push -f`) unless you know _exactly_ what you are doing!
13. Additional resources
- Git under the hood: Advanced Git: Graphs, Hashes, and Compression, Oh My! (https://www.youtube.com/watch?v=ig5E8CcdM9g)
