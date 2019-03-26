#!/usr/bin/env bash

# fzf to select from files sorted by modifcation time
#  replace anti-pattern 
#   ls -tlc|head
#   copy
#   paste
#
# 20190326WF -- init, copy of fuzzy_arg.bash

## 
# show files and how many days old they are in days
_new_files() { 
   \ls -tc |  perl -lne 'print sprintf("%.1f\t%s", -M $_, $_)'
}

# how to show choices
#_fuzzy_menu() { rofi -dmenu -matching fuzzy; } # X11 with rofi in dmenu mode

# https://github.com/junegunn/fzf
_fuzzy_menu() { fzf +s; }  # no sort

# how to insert into
# https://unix.stackexchange.com/questions/391679/how-to-automatically-insert-a-string-after-the-prompt
# https://bbs.archlinux.org/viewtopic.php?id=199495, cf. h2ph
_bash_insert() { perl -le 'ioctl(STDIN,0x5412,$_) for split "", join " ", @ARGV' -- "$@";}

# put it all together
_lookup_new_files() { _bash_insert $(_new_files | _fuzzy_menu |sed 's/^.*\?\t//' ); }

# bind to keys (alt+a, ctrl+x ctrl+a)
bind -x '"\en":"_lookup_new_files"'
bind -x '"\C-x\C-n":"_lookup_new_files"'
