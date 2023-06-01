FROM rockylinux:9

LABEL description="image to make slurm rpm"
USER root
# install dependencies
RUN \
    dnf -y update && \
    dnf -y install 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled devel && \
    dnf -y update && \
    dnf -y install --setopt=tsflags=nodocs epel-release && \
    dnf -y install --setopt=tsflags=nodocs \
        vim wget bzip2 \
        autoconf make gcc rpm-build \
        openssl openssh-clients openssl-devel \
        mariadb-server mariadb-devel \
        munge munge-devel munge-libs\
        readline readline-devel \
        hdf5 hdf5-devel pam-devel hwloc hwloc-devel \
        perl perl-ExtUtils-MakeMaker python3 \
        libjwt libjwt-devel \
        glib2-devel

# source of slurm
# git archive --format=tar.gz -o ../slurm_model/docker/slurm-23.11.0-0rc1.tar.gz --prefix=slurm-23.11.0-0rc1/ slurm-23-02-reg
# gunzip < slurm-23.11.0-0rc1.tar.gz | bzip2 > slurm-23.11.0-0rc1.tar.bz2
# ENV SLURM_TAR_BZ2_SOURCE=https://download.schedmd.com/slurm/slurm-23.02.1.tar.bz2
COPY docker/slurm-23.11.0-0rc1.tar.bz2 /root/slurm-23.11.0-0rc1.tar.bz2
# volume for final rpms dump
VOLUME ./docker/RPMS

# setup entry point
WORKDIR /root

COPY ./docker/make_slurm_rpms ./docker/utils/cmd_setup ./docker/utils/cmd_start ./docker/utils/cmd_stop /usr/local/sbin/
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["make_slurm_rpms"]
