# homebrew

Managing packages using homebrew

## list of installed packages

There is an up-to-date list of all installed packages in `~/.config/Brewfile`

In order to install all packages in this file, just run
```
$ brew bundle --file ~/.config/Brewfile
```

A simple command to list all installed packages is
```
$ brew deps --installed
```
