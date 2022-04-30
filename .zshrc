#
# Example .zshrc file for zsh 4.0
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#


# Search path for the cd command
cdpath=(.. ~ ~/src ~/zsh)

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s
export TERM="xterm-256color"
umask 022

# Set up aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias grep='egrep --color'
alias ll='ls -l'
alias la='ls -a'
alias lsd='ls -ld *(-/DN)'
alias weka='java -classpath /Applications/weka-3-5-7/libsvm.jar:/Applications/weka-3-5-7/weka.jar -Xmx1024m weka.gui.GUIChooser'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
bup () { for  file in $argv ; do ; mv $file $file.`date +%d%m%y`; done}
latexdvipdf () {latex $argv.tex; dvipdf $argv.dvi; acroread $argv.pdf}

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man /usr/share/man  )
export MANPATH

# Hosts to use for completion (see later zstyle)
hosts=(`hostname` ftp.math.gatech.edu prep.ai.mit.edu wuarchive.wustl.edu)

# Set prompts
#PROMPT='%B|%n@%m[%!]>%B '    # default prompt
#RPROMPT=' %B%d%B'     # prompt for right side of screen
autoload -U colors && colors

PROMPT="%B%{$fg[cyan]%}|%n%{$reset_color%}@%{$fg[red]%}%m%{$fg_no_bold[cyan]%}[%!]>%{$reset_color%} "
RPROMPT="%{$fg_no_bold[yellow]%}%3d%{$reset_color%}"
# Some environment variables
export MAIL=/var/spool/mail/$USERNAME
export LESS=-cex3M
export HELPDIR=/usr/local/lib/zsh/help  # directory for run-help function to find docs
PATH=:/bin:$PATH:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
PATH=~/opt/anaconda3/bin:$PATH:
MAILCHECK=300
HISTSIZE=200
DIRSTACKSIZE=20
MAILCHECK=300
HISTSIZE=200
DIRSTACKSIZE=20

# Watch for my friends
#watch=( $(<~/.friends) )       # watch for people in .friends file
watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# bindkey -v               # vi key bindings
bindkey "^?" backward-delete-char
bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
export EDITOR=vim
bindkey -v
eval "$(fasd --init posix-alias zsh-hook)"
#eval "$(pyenv init -)"
if [ -n "$INSIDE_EMACS" ]; then
    export EDITOR=emacsclient
    unset zle_bracketed_paste  # This line
fi
figlet -w 100 `hostname`; fortune | cowsay; ansiweather -l Botucatu,BR -u metric -s true -a false

# The next line enables shell command completion for gcloud.
if [ -f /Users/neylemke/Downloads/google-cloud-sdk/completion.zsh.inc ]; then
  source '/Users/neylemke/Downloads/google-cloud-sdk/completion.zsh.inc'
  fi

  eval "$(fasd --init auto)"
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  POWERLEVEL9K_SHORTEN_DELIMITER=""
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
source  ~/powerlevel9k/powerlevel9k.zsh-theme
#Better colors
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1
#Syntax Highlighting 
source /Users/neylemke/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/neylemke/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/neylemke/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/neylemke/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/neylemke/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/neylemke/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/neylemke/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/neylemke/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/neylemke/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

