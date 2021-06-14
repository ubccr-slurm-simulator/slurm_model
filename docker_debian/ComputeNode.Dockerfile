FROM pseudo/slurm_common:latest

LABEL description="Compute Node Image for Slurm Virtual Cluster"

USER root

#copy slurm deb
COPY ./docker_debian/DEB/slurm*.deb /root/
COPY ./docker/password-auth /etc/pam.d/password-auth

#install Slurm
Run apt-get install -y \

