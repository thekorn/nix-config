# config using nix and flake

This is my experiment to convert my dotfiles based configuration to nix

## prerequisits

 * git
 * homebrew
 * clone this repository

```
$ git clone https://github.com/thekorn/nix-config.git .config/nix
```

 * install nix

```
$ sh <(curl -L https://nixos.org/nix/install) 
```

```
$ cd .config/nix
$ nix build .#darwinConfigurations.test.system --extra-experimental-features "nix-command flakes"

# the plan is to now run this to install nix-darwin with our configuration
# ./result/sw/bin/darwin-rebuild switch --flake . # this will fail as we first have to do the following lines

$ printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
$ /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# now we can finally darwin-rebuild
$ ./result/sw/bin/darwin-rebuild switch --flake .
```

## reference

 * https://github.com/thexyno/blogpages.git 
 * https://daiderd.com/nix-darwin/manual/index.html
 * https://nix-community.github.io/home-manager/options.html