##  pull the centos image
```
docker pull centos:7
```
## run in priviliged mode 
```
docker run --privileged -it --name=centos-with-ssh centos:7 /sbin/init
```
## open sshd server from another terminal
```
docker exec -it centos-with-ssh /bin/bash
```

## install sshd server 
```
yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs \
        vim tmux mc perl-Switch\
        openssl openssh-server openssh-clients \
        mariadb-server \
        munge sudo && \
    yum clean all
```

## add user
```
useradd -ms /bin/bash user2 -p user
``` 
- add a sudo user
  - usermod -aG wheel username
- swhich user
  - su username
- change passwd
  - passwd username


systemctl restart sshd.service

## start the sshd server 
systemctl restart sshd.service

cmd_start sshd
  
  
  
# Making Common Image

```bash
## Build
docker build -f centos_slurm_single_host_wlm/DockerfileCommon -t slurm_common:latest .

## Run
d
docker run -it --rm -h compute000 -p 222:22 --name compute000 slurm_common:latest
```
