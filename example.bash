#!/usr/bin/env bash

BREAK=1
PAUSE=.5
typeit(){ xdotool sleep $PAUSE type -delay 50 "$1"; }
fzarg(){ xdotool sleep $PAUSE key alt+a; typeit "$1"; xdotool sleep $PAUSE key Return; }

runit() {
  # record example
  sleep 2
  typeit 'echo "some long string might need again" > /tmp/long_file_name_that_is_hard_to_tab_complete'
  typeit 'echo "a different long stretch of characters" > /tmp/long_file_name_copy_should_remove_this'
  typeit 'diff '
  fzarg 'long tab'
  xdotool sleep $BREAK key ctrl+a sleep .05 key alt+f sleep .05 key space sleep $PAUSE
  fzarg 'long rm'
  xdotool key Return sleep $BREAK

  typeit 'grep '
  fzarg 'str again'
  xdotool sleep $PAUSE
  typeit ' /tmp/long_file_name*'
  xdotool sleep $BREAK
  typeit 'rm '
  fzarg 'long rm'
  xdotool sleep $BREAK key space
  fzarg 'long tab'
  xdotool sleep $PAUSE key Return
  xdotool sleep $BREAK key ctrl+d
}
[ -r example.cast ] && rm example.cast
runit &
asciinema rec example.cast
