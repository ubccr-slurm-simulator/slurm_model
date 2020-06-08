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

 
 
# Making Headnode

## Manual making

```bash
# Build
docker build -f centos_slurm_single_host_wlm/DockerfileCommon -t slurm_common:latest .

# Start network
docker network create -d bridge virtual-cluster

# Start head-node
docker run -it --rm -h head-node -p 222:22 --name head-node \
   --network virtual-cluster \
    -v `pwd`:/slurm_model -v `pwd`/micro/etc:/etc/slurm slurm_common:latest

# On head-node

yum -y install mariadb-server

#configure mysqld
chmod g+rw /var/lib/mysql /var/log/mariadb /var/run/mariadb && \
    mysql_install_db && \
    chown -R mysql:mysql /var/lib/mysql && \
    cmd_start mysqld && \
    mysql -e 'DELETE FROM mysql.user WHERE user NOT LIKE "root";' && \
    mysql -e 'DELETE FROM mysql.user WHERE Host NOT IN ("localhost","127.0.0.1","%");' && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;' && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;' && \
    mysql -e 'DROP DATABASE IF EXISTS test;' && \
    cmd_stop mysqld

cmd_start mysqld 


# setup munge
echo "secret munge key secret munge key secret munge key" >/etc/munge/munge.key &&\
    chown -R munge:munge /var/log/munge /run/munge /var/lib/munge /etc/munge &&\
    chmod 600 /etc/munge/munge.key &&\
    cmd_start munged &&\
    munge -n | unmunge
cmd_start munged 

cd /slurm_model/centos_slurm_single_host_wlm/RPMS/x86_64

yum -y install \
slurm-20.02.3-1.el7.x86_64.rpm \
slurm-perlapi-20.02.3-1.el7.x86_64.rpm \
slurm-slurmctld-20.02.3-1.el7.x86_64.rpm \
slurm-slurmdbd-20.02.3-1.el7.x86_64.rpm

mkdir /var/log/slurm
chown -R slurm:slurm /var/log/slurm

mkdir /var/state
chown -R slurm:slurm /var/state

mkdir -p /var/spool/slurmd
chown -R slurm:slurm /var/spool/slurmd


#ports on head SlurmctldPort=29002 on compute SlurmdPort=29003

# debug start:
slurmdbd -D -v -v -v
slurmctld -D -v -v -v

# normal start
cmd_start slurmdbd slurmctrld


```
 
## With dockerfile making

```bash
# Build
docker build -f centos_slurm_single_host_wlm/DockerfileCommon -t slurm_common:latest .
docker build -f centos_slurm_single_host_wlm/DockerfileHeadNode -t slurm_head_node:latest .
docker build -f centos_slurm_single_host_wlm/DockerfileComputeNode -t slurm_compute_node:latest .

# Start network
docker network create -d bridge virtual-cluster

# Start head-node
docker run -it --rm -h head-node -p 222:22 --name head-node \
   --network virtual-cluster \
    -v `pwd`:/slurm_model -v `pwd`/micro1/etc:/etc/slurm slurm_head_node:latest
    
# Start compute
docker run -it --rm -h compute000 --name compute000 \
   --network virtual-cluster \
   -v `pwd`/micro1/etc:/etc/slurm slurm_compute_node:latest

```
