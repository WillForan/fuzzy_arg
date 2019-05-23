#!/usr/bin/env bats

setup() { source fuzzy_new_complete.bash; }
last() {
  r=$(_last_partial_arg "$1")
  if ! [ "$r" == "$2" ]; then
    echo -e "from\t$1\nget:\t$r\nwant\t$2" >&3
    return 1
  else
    return 0
  fi
    
}

@test "easy" { last "foo bar baz" "baz"; }
@test "escaped space" { last "junk foo\ bar\ baz" "foo bar baz"; }
@test "simple single quote" { last "foo 'bar baz" "bar baz"; }
@test "ignore escaped double quote" { last "foo \\\"bar baz" "baz" ; }
@test "escaped double quote in double" { last 'foo "bar\" baz'   'bar" baz'; }
@test "double quote in sinqle" { last "foo 'bar\" baz" 'bar" baz'; }
