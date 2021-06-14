FROM pseudo/slurm_common:latest

LABEL description="Compute Node Image for Slurm Virtual Cluster"

USER root

#copy slurm deb
COPY ./docker_debian/DEB/slurm*.deb /root/
COPY ./docker/password-auth /etc/pam.d/password-auth

#install Slurm
Run dpkg --install \
	slurm-[0-9]*.deb && \
    rm slurm*.deb  && \
    mkdir /var/log/slurm  && \
    chown -R slurm:slurm /var/log/slurm  && \
    mkdir /var/state  && \
    chown -R slurm:slurm /var/state  && \
    mkdir -p /var/spool/slurmd  && \
    chown -R slurm:slurm /var/spool/slurmd

EXPOSE 29003

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["-loop", "/vctools/init_system", "munged", "slurmd", "sshd", "/vctools/init_slurm", "bash"]
