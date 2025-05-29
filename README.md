# config using nix and flake

This is the config for my machines.

## prerequisits

- git
- homebrew

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- clone this repository

```
$ git clone https://github.com/thekorn/nix-config.git .config/nix
```

- install nix

```
$ curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

- install nix-darwin

```
$ sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
```

```
$ cd .config/nix
$ nix build .#darwinConfigurations.demoVM.system --extra-experimental-features "nix-command flakes"

# the plan is to now run this to install nix-darwin with our configuration
# ./result/sw/bin/darwin-rebuild switch --flake .#demoVM # this will fail as we first have to do the following lines

# now we can finally darwin-rebuild
$ ./result/sw/bin/darwin-rebuild switch --flake .#demoVM
```

## reference

- https://github.com/thexyno/blogpages.git
- https://daiderd.com/nix-darwin/manual/index.html
- https://nix-community.github.io/home-manager/options.html
- https://codeberg.org/imMaturana/dotfiles
- https://github.com/schickling/dotfiles
