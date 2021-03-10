#!/usr/bin/env bash

# BASH: complete files sorted by date using alt+n instead of tab
# https://unix.stackexchange.com/questions/90943/how-to-order-files-by-date-in-tab-completion-list

# USAGE:
#  source fuzzy_new_complete.bash
#  7z ~/Downloads/[alt+n]
#
#
# for zsh consider something like
#   autoload -U compinit
#   compinit
#   zstyle ':completion:*' file-sort modification reverse

# given a string, find last argument
# has an eye for potentially dangling quote: like '/path/to thing with/spa
# respects escaped spaces (and escaped quotes within a quote)
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


# given a directory or partial path, find the newst files there
# does not recurse into sub directories
_find_newest() {
   local dir fpart part input
   # ~ is okay but "~" is not.
   # quotes would be needed if there are spaces in folder name/file part
   # but i don't think we'd ever see input with spaces
   # thats up to _last_partial_arg
   input="$@"
   [[ "$input" =~ ^~ ]] && input="$HOME/${input:1}"
   # directories have no file part. use all
   if [ -d "$input" ]; then
      dir="$input"
      fpart="*"
   # but potnetionally incomplete paths do have file parts
   else
      dir="$(dirname "$input")"
      fpart="$(basename "$input")*"
   fi
   # '~/': dir: '.', part '~*'
   # find files, exclude the directoyr itself
   # sort by mod time
   find "$dir" -maxdepth 1 -name "$fpart" -printf "%TY%Tm%Td-%TT %p\n" |
       egrep -v " $dir$" |
       sort -rn
}

# use in bind:
# use point to find arugment we are over and try to "tab complete" it
# but sort files by date
_newfile_at_point() {
    local upto="${READLINE_LINE:0:$READLINE_POINT}"
    upto=$(_last_partial_arg "$upto")
    local f=$(_find_newest "$upto" | fzf +s|cut -d' ' -f2)
    if [ -n "$f" ]; then
       # update readline to
       # - exclude the part we completed on
       # - insert the new competed file
       NEWSTART=$[$READLINE_POINT - ${#upto}]
       REST="${READLINE_LINE:$READLINE_POINT}"
       # update readline
       READLINE_LINE="${READLINE_LINE:0:$NEWSTART}$f$REST"
       # move point to after completion
       READLINE_POINT=$[${NEWSTART}+${#f}]
    fi
    return
}

# bind to alt+n
bind -x '"\en":"_newfile_at_point"'
