# Fuzzy Arg
<kbd>Ctrl-r</kbd> for <kbd>Alt-.</kbd>

## Usage
default bindings are to <kbd>alt-a</kbd> and <kbd>Ctrl-x Ctrl-a</kbd>. Use either to fuzzy find arguments in your shell history.

## Install
```bash
# if you're too trusting, espeically lazy, and not concerned about updates
curl https://raw.githubusercontent.com/WillForan/fuzzy_arg/master/fuzzy_arg.bash >> $HOME/.bashrc
```

 OR

```bash
git clone https://github.com/WillForan/fuzzy_arg
cd fuzzy_arg
# review code
echo "source $(pwd)/fuzzy_arg.bash" >> $HOME/.bashrc
```

## Example

[![example](https://asciinema.org/a/piZnUrRVqqTzbDc4S9VsvaCyl.png)](https://asciinema.org/a/piZnUrRVqqTzbDc4S9VsvaCyl?autoplay=1)

after sourcing `fuzzy_arg.bash` or adding to and re-sourcing `~/.bashrc`

```
# setup. pretend this are meaningful commands
echo "some long string might need again" > /tmp/long_file_name_that_is_hard_to_tab_complete
echo "a different long stretch of characters" > /tmp/long_file_name_copy_should_remove_this

diff 
 # interactive
 #   M-a:   fuzzy search one of the files ('long tab'), enter to insert
 #   C-a M-f: to get in the middle of the line
 #   M-a: fuzzy insert again ('long rm'), puts text wher the cursor is

echo # M-a 'str agn'
```

# fuzzy new files

replace the anti-pattern of
```
ls -tlc |head
[copy]
cmd-for-new-file [paste]
```
<kbd>Alt+n</kbd> from `source fuzzy_new_files.bash`
