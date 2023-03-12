# docker

## Clean up local disk space by removing docker images

```sh
$ docker rm `docker ps --no-trunc -aq`
$ docker rmi $(docker images -q)
```