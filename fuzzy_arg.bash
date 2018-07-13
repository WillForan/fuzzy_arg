#!/usr/bin/env bash

# Ctrl-r for Alt-.
#
# Find command arguments from history and insert them at current point on the console
# 
#
# 20180712 WF

## 
# get individual words from the shell's history
_hist_words() { 
   history | # tail |
   perl -MText::ParseWords -lne '
     # remove leading number
     s/^ +\d+ +//; 
     # split words (include "a word"), push to array if unique
     for(quotewords("\\s+\|\\\|",1,$_)){
        push @a, $_ if $h{$_}++ < 1 and length($_)>1
     };
     # print in reverse order (newest first)
     END{print $_ for reverse(@a)}
   '
}

# how to show choices
#_fuzzy_menu() { rofi -dmenu -matching fuzzy; } # X11 with rofi in dmenu mode
_fuzzy_menu() { fzf; } # https://github.com/junegunn/fzf

# how to insert into
# https://unix.stackexchange.com/questions/391679/how-to-automatically-insert-a-string-after-the-prompt
# https://bbs.archlinux.org/viewtopic.php?id=199495, cf. h2ph
_bash_insert() { perl -le 'ioctl(STDIN,0x5412,$_) for split "", join " ", @ARGV' -- "$@";}

# put it all together
_lookup_args() { _bash_insert $(_hist_words | _fuzzy_menu ); }

# bind to keys (alt+a, ctrl+x ctrl+a)
bind -x '"\ea":"_lookup_args"'
bind -x '"\C-x\C-a":"_lookup_args"'
