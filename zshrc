# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


##
# Completion
##

# Load more completions
fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)

# Should be called before compinit
zmodload zsh/complist

autoload -U compinit
compinit -i
_comp_options+=(globdots) # With hidden files

setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification


zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

##
# Pushd
##
setopt auto_pushd                            # make cd push old dir in dir stack
setopt pushd_ignore_dups                     # no duplicates in dir stack
setopt pushd_silent                          # no dir stack after pushd or popd
setopt pushd_to_home                         # `pushd` = `pushd $HOME`

##
# History
##
HISTFILE=~/.zsh_history                      # where to store zsh config
HISTSIZE=10240                               # big history
SAVEHIST=10240                               # big history
setopt append_history                        # append
setopt hist_ignore_all_dups                  # no duplicate
setopt hist_ignore_space                     # ignore space prefixed commands
setopt hist_reduce_blanks                    # trim blanks
setopt hist_verify                           # show before executing history commands
setopt inc_append_history                    # add commands as they are typed, don't wait until shell exit
setopt share_history                         # share hist between sessions
setopt bang_hist                             # !keyword

##
# Various
##
setopt auto_cd                               # if command is a path, cd into it
setopt auto_remove_slash                     # self explicit
setopt chase_links                           # resolve symlinks
setopt correct                               # try to correct spelling of commands
setopt extended_glob                         # activate complex pattern globbing
setopt glob_dots                             # include dotfiles in globbing
setopt print_exit_value                      # print return value if non-zero
unsetopt beep                                # no bell on error
unsetopt bg_nice                             # no lower prio for background jobs
unsetopt clobber                             # must use >| to truncate existing files
unsetopt hist_beep                           # no bell on error in history
unsetopt hup                                 # no hup signal at shell exit
unsetopt ignore_eof                          # do not exit on end-of-file
unsetopt list_beep                           # no bell on ambiguous completion
unsetopt rm_star_silent                      # ask for confirmation for `rm *' or `rm path/*'
print -Pn "\e]0; %n@%M: %~\a"                # terminal title

# echo $(realpath "${0:a}")
source "$(realpath "${0:a:h}")/aliases"      # aliases
source "$(realpath "${0:a:h}")/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
