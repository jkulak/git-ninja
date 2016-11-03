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
