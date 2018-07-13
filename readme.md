# Fuzzy Arg
<kbd>Ctrl-r</kbd> for <kbd>Alt-.</kbd>


## Install
default binds to <kbd>alt-a</kbd> and <kbd>Ctrl-x Ctrl-a</kbd>
```bash
# if you're too trusting, espeically lazy, and not concerned about updates
curl https://raw.githubusercontent.com/WillForan/fuzzy_arg/master/fuzzy_arg.bash >> $HOME/.bashrc
# OR
git clone https://github.com/WillForan/fuzzy_arg
cd fuzzy_arg
# review code
echo "source $(pwd)/fuzzy_arg.bash" >> $HOME/.bashrc
```

## Example
after sourcing `fuzzy_arg.bash` or adding to and re-sourcing `~/.bashrc`
```
# setup. pretend this are meaningful commands
echo "some long string might need again" > /tmp/long_file_name_that_is_hard_to_tab_complete
echo "a different long stretch of characters" > /tmp/long_file_name_copy_should_remove_this

diff #[push alt+a here diff to grab each long file]
```

N.B. in this example the builtin <kbd>Alt+.</kdb> would be easier.
