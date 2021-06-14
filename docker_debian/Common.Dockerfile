FROM ubuntu

LABEL description="Common Image for Slurm Virtual Cluster"
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN \
    apt-get update -y && \
    apt-get install -y \
        vim tmux mc \
        libswitch-perl \
        openssl openssh-server openssh-client iproute2 \
        perl-Date* \
        gcc g++ \
        munge sudo python3 make && \
    apt-get clean all

WORKDIR /root

# copy daemons starters
COPY ./docker_debian/utils/cmd_setup ./docker_debian/utils/cmd_start ./docker_debian/utils/cmd_stop /usr/local/sbin/
COPY ./docker_debian/vctools /vctools
# directories
RUN mkdir /scratch && chmod 777 /scratch
RUN mkdir /scratch/jobs && chmod 777 /scratch/jobs

# add users
RUN useradd -m -s /bin/bash slurm && \
    echo 'slurm:slurm' |chpasswd && \
    usermod -a -G sudo slurm && \
    echo "slurm ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    
# configure sshd
RUN mkdir /var/run/sshd && \
    yes | sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    yes | sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    yes | sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    echo 'root:root' |chpasswd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# uncomment two previous line if there is a need for root access through ssh

RUN ls /run

# setup munge
RUN echo "secret munge key secret munge key secret munge key" >/etc/munge/munge.key &&\
    mkdir /run/munge && \
    chown -R munge:munge /var/log/munge /run/munge /var/lib/munge /etc/munge &&\
    chmod 600 /etc/munge/munge.key &&\
    cmd_start munged &&\
    munge -n | unmunge &&\
    cmd_stop munged

EXPOSE 22

# install miniapps
COPY ./miniapps /usr/local/miniapps
RUN cd /usr/local/miniapps && make

# edit system processor limits
RUN sudo echo -e "# Default limit for number of user's processes to prevent \n \
 *          \soft    nproc     unlimited \n root       soft    nproc     unlimited" \
> /etc/security/limits.d/20-nproc.conf

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["sshd", "bash"]
