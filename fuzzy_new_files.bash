#!/usr/bin/env bash

# fzf to select from files sorted by modifcation time
#  replace anti-pattern 
#   ls -tlc|head
#   copy
#   paste
#
# 20190326WF -- init, copy of fuzzy_arg.bash

# DEPENDS:
#   needs _fuzzy_menu and  _{zsh,bash}_insert from fuzzy_arg.bash

## 
# show files and how many days old they are in days
_new_files() { 
   \ls -tc |  perl -lne 'print sprintf("%.1f\t%s", -M $_, $_)'
}

# put it all together
_lookup_new_files() { _${_SHELL}_insert $(_new_files | _fuzzy_menu |sed 's/^.*\?\t//' ); }

# bind to keys 

if [ $(basename $SHELL) = "zsh" ]; then
   zle -N _lookup_new_files
   bindkey "^[n" _lookup_new_files
else
   bind -x '"\en":"_lookup_new_files"'
   bind -x '"\C-x\C-n":"_lookup_new_files"'
fi
