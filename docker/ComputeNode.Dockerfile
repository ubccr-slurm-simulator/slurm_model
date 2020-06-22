FROM pseudo/slurm_common:latest

LABEL description="Compute Node Image for Slurm Virtual Cluster"

# copy slurm rpm
COPY ./docker/RPMS/x86_64/slurm*.rpm /root/
COPY ./micro1/bin/slurm-epilog /usr/local/bin/slurm-epilog
COPY ./micro1/bin/slurm-prolog /usr/local/bin/slurm-prolog
COPY ./docker/password-auth /etc/pam.d/password-auth

#install Slurm
RUN yum -y install \
        slurm-[0-9]*.x86_64.rpm \
        slurm-perlapi-*.x86_64.rpm \
        slurm-slurmd-*.x86_64.rpm \
        slurm-pam_slurm-*.x86_64.rpm && \
    rm slurm*.rpm  && \
    mkdir /var/log/slurm  && \
    chown -R slurm:slurm /var/log/slurm  && \
    mkdir /var/state  && \
    chown -R slurm:slurm /var/state  && \
    mkdir -p /var/spool/slurmd  && \
    chown -R slurm:slurm /var/spool/slurmd

EXPOSE 29003

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["-loop", "munged", "slurmd", "sshd", "bash"]
