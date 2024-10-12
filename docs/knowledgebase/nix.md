# nix

## clean up the store

In order to free up space in the store, you can run the following command:

```bash
nix-store --gc
nix-collect-garbage --delete-older-than 14d
```

## use a github access token

for authenticated fetching of nix packages to increase the rate limit.

1) create a github access [token](https://github.com/settings/tokens?type=beta)

2) create a file `~/.config/nix/nix.conf` with the following content:

```bash
$ cat ~/.config/nix/nix.conf
access-tokens = github.com=***censored***
```

## pinning packages

one way is to vendor packages https://jade.fyi/blog/pinning-packages-in-nix/
