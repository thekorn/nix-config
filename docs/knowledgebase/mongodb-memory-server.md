# mongodb-memory-server on ubuntu > 20.04

Until now mongodb has no build ubuntu 22.04 (or its derivates). in order to make it run anyways, run\

```
echo "deb http://security.ubuntu.com/ubuntu impish-security main" | sudo tee /etc/apt/sources.list.d/impish-security.list
sudo apt-get update
sudo apt-get install libssl1.1
```