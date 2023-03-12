# git

## delete all merged git branches locally

```sh
$ git branch -d $( git branch --merged | grep -v '^\*' | grep -v 'master' | grep -v 'main' )
``` 

## delete all merged git branches on the remote

Before running the command you might want to make sure that your local cache is pruned and in sync with the remote state
```sh
$ git fetch -p origin
```

then run
```sh
$ git branch -r --merged | grep -v master | grep -v main | grep -v develop | sed 's/origin\///' | xargs -n 1 git push --delete origin
```

## submodules

### change the origin url of a submodule

Taken from [this blogpost](https://www.damirscorner.com/blog/posts/20210423-ChangingUrlsOfGitSubmodules.html)

 1. Modify the URL value in the `.gitmodules` file. This file gets committed to Git.
 2. Force submodules to resynchronize with the modified file using the following command:
    ```
    $ git submodule sync
    ```
 3. Update all modules from the now correct remote URL using the following command (because it is called recursively on all submodules, even nested ones):
    ```
    $ git submodule update --init --recursive --remote
    ```