FROM centos:7

LABEL description="Common Image for Slurm Virtual Cluster"

# install dependencies
RUN \
    yum -y update && \
    yum -y install --setopt=tsflags=nodocs epel-release && \
    yum -y install --setopt=tsflags=nodocs \
        vim tmux mc perl-Switch\
        openssl openssh-server openssh-clients iproute \
        perl-Date* \
        gcc-c++ \
        munge sudo python3 && \
    yum clean all

WORKDIR /root

# copy daemons starters
COPY ./docker/utils/cmd_setup ./docker/utils/cmd_start ./docker/utils/cmd_stop /usr/local/sbin/
COPY ./docker/vctools /vctools
# directories
RUN mkdir /scratch && chmod 777 /scratch

# add users
RUN useradd -m -s /bin/bash slurm && \
    echo 'slurm:slurm' |chpasswd && \
    usermod -a -G wheel slurm && \
    echo "slurm ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    
# configure sshd
RUN mkdir /var/run/sshd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    echo 'root:root' |chpasswd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# uncomment two previous line if there is a need for root access through ssh

# setup munge
RUN echo "secret munge key secret munge key secret munge key" >/etc/munge/munge.key &&\
    chown -R munge:munge /var/log/munge /run/munge /var/lib/munge /etc/munge &&\
    chmod 600 /etc/munge/munge.key &&\
    cmd_start munged &&\
    munge -n | unmunge &&\
    cmd_stop munged

EXPOSE 22

# install mini miniapps
COPY ./apps /usr/local/apps
RUN cd /usr/local/apps && make

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["sshd", "bash"]
