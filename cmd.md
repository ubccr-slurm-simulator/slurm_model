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
docker run -it --rm -h compute000 -p 222:22 --name compute000 slurm_common:latest
```

# install Slurm

### install Dependecy 
RUN \
    yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs \
        vim wget bzip2 \
        autoconf make gcc rpm-build \
        openssl openssh-clients openssl-devel \
        mariadb-server mariadb-devel \
        munge munge-devel \
        readline readline-devel \
        pam-devel \
        perl perl-ExtUtils-MakeMaker\
        python3\

### pass slurm to docker 
```
docker cp slurm-20.02.3.tar.bz2 head-node-slurm-net:/root
// wget https://download.schedmd.com/slurm/slurm-20.02.3.tar.bz2
```

### unpack the zip
```
tar -jxvf slurm-20.02.3.tar.bz2
```
### build it
rpmbuild -ta slurm-20.02.3.tar.bz2 

cp -rf rpmbuild/RPMS/x86_64 /RPMS

## for controler
rpm --install /RPMS \slurm-20.02.3-1.el7.x86_64.rpm\
        slurm-perlapi-20.02.3-1.el7.x86_64.rpm
        slurm-slurmctld-*.x86_64.rpm \
        slurm-slurmdbd-*.x86_64.rpm  && \


## config 
### dependency
   yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs \
        vim tmux mc perl-Switch\
        openssl openssh-server openssh-clients \
        mariadb-server \
        munge sudo && \
    yum clean all


### munge
echo "secret munge key secret munge key secret munge key" >/etc/munge/munge.key &&\
    chown -R munge:munge /var/log/munge /run/munge /var/lib/munge /etc/munge &&\
    chmod 600 /etc/munge/munge.key &&\
    cmd_start munged &&\
    munge -n | unmunge &&\
    cmd_stop munged

### upload slurm config file 
docker cp slurm.conf head-node:etc/slurm/slurm.conf
docker cp slurmdbd.conf head-node:etc/slurm/slurmdbd.conf


# error:
  munged: Error: Found pid 53940 bound to socket "/var/run/munge/munge.socket.2"



## start munged
 chmod a+r /etc/slurm/slurm.conf &&\ cmd_start munged

 chmod a+r /etc/slurm/slurmdbd.conf

