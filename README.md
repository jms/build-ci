# build-ci
Docker images with node 8, python2/3, chromium browser, postgresql and java suitable for jenkins builds


for frontend tests using puppeter add this args

```bash
    -v /dev/shm:/dev/shm --security-opt seccomp=$(pwd)/chrome.json
```
chrome.json:

`wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`

Thanks to Jessie Frazelle seccomp profile for Chrome.


for postgresql it use the same params like the official image. 

reference: https://hub.docker.com/_/postgres/

env variables: 
- POSTGRES_PASSWORD
- POSTGRES_USER
- PGDATA
- POSTGRES_DB
- POSTGRES_INITDB_ARGS
- POSTGRES_INITDB_WALDIR


```bash
docker run --name some-postgres -it jmsanchez/build-ci -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```