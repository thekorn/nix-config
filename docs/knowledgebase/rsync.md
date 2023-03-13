# rsync

common commandline to backup the `devel/` folder:

```
  $ rsync -auvhp --delete --exclude=node_modules --exclude=build --exclude=temp --progress ~/devel .
```