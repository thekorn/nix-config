# nix

## clean up the store

In order to free up space in the store, you can run the following command:

```bash
nix-store --gc
nix-collect-garbage --delete-older-than 14d
```

in order to aggressivly remove all old generations of the store, run

```bash
nix-collect-garbage -d
```

to optimize the store, run

```bash
nix store optimise
```

on nix os, in order to free up `/boot` space, you can run the following command:

```bash
sudo nix-collect-garbage --delete-old
sudo nixos-rebuild switch
```

## use a github access token

for authenticated fetching of nix packages to increase the rate limit.

1. create a github access [token](https://github.com/settings/tokens?type=beta)

2. create a file `~/.config/nix/nix.conf` with the following content:

```bash
$ cat ~/.config/nix/nix.conf
access-tokens = github.com=***censored***
```

## pinning packages

one way is to vendor packages https://jade.fyi/blog/pinning-packages-in-nix/

## update inputs

```bash
nix flake update
```

## update nix

get the current nix version:

```bash
nix-shell -p nix -I nixpkgs=channel:nixpkgs-unstable --run "nix --version"
```

update on linux:

```bash
$ sudo su
nix-env --install --file '<nixpkgs>' --attr nix cacert -I nixpkgs=channel:nixpkgs-unstable
systemctl daemon-reload
systemctl restart nix-daemon
```

update on macos:

```bash
sudo nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
sudo launchctl remove org.nixos.nix-daemon
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

update Determinate nix:

```bash
sudo determinate-nixd upgrade
```

## locate a file

1. create the database:

```bash
nix run github:nix-community/nix-index#nix-index
```

2. query for a file:

```bash
nix run github:nix-community/nix-index#nix-locate -- bin/hello
```
