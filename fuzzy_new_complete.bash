#!/usr/bin/env bash

# complete files sorted by date using alt+n instead of tab
# TODO: cannot send ^H to terminal with perl+ioctl
#  "Modification of a read-only value attempted at -e line 1."
#
# https://unix.stackexchange.com/questions/90943/how-to-order-files-by-date-in-tab-completion-list
#
# for zsh consider something like
#   autoload -U compinit
#   compinit
#   zstyle ':completion:*' file-sort modification reverse

# given a string up to where the cursor is, find what the last argument is
_last_partial_arg() {
 echo "$@" |
    perl -pe '
     s/\\ /\0/g; # replace escaped spaces with nulls
     s/\\"/\001/g; # replace escaped spaces with nulls
     # single quotes
     $end = /(?!\\)[^'\'']*$/ ? $& : $_; # remove up to last single quote
     if(/'\''/g % 2 == 1) { # if odd number of singles, remove spaces
      $end =~ s/ /\0/g;
      $end =~ s/"/\001/g;
     }
     $_=$end;
     # double quotes
     $end = /(?!\\)[^"]*$/ ? $& : $_; # remove up to last single quote
     $end =~ s/ /\0/g if /"/g % 2 == 1; # if odd number of singles, remove spaces
     $_=$end;

     $_ = /(?!\\)[^\s]*$/ ? $& : $_;
     s/^.* //; # remove any leading space
     s/\0/ /g; # put spaces back
     s/\001/"/g; # put double quotes back
    ' 
}

_find_newest() {
  find "$(dirname "$1")" -maxdepth 1 -name "$(basename "$1")*" -printf "%TY%Tm%Td-%TT %p\n" | sort -rn
}

_newfile_at_point() {
    local upto="${READLINE_LINE:0:$READLINE_POINT}"
    upto=$(_last_partial_arg "$upto")
    local f=$(_find_newest "$upto" | fzf +s|cut -d' ' -f2)
    if [ -n "$f" ]; then
       perl -le 'ioctl(STDIN,0x5412,"") for (1..$ARGV[0])' -- ${#upto} 
       perl -le 'ioctl(STDIN,0x5412,$_) for split "", join " ", @ARGV' -- "$f"
    fi
    return
}

bind -x '"\en":"_newfile_at_point"'
