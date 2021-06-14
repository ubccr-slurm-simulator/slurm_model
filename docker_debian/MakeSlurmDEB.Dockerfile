#update ubuntu version later
FROM ubuntu

LABEL description="instructions to make slurm deb"
USER root
ARG DEBIAN_FRONTEND=noninteractive

ENV DEBEMAIL="wmathias@umich.edu"
ENV DEBFULLNAME="William Mathias"

#install dependencies
RUN \
    apt-get update -y && \
    apt-get install -y \
        vim wget bzip2 \
	dh-make \
	libgtk2.0-dev \
        openssl \ 
        #openssh-clients openssl-devel \
        mysql* \
        munge \
        #munge-devel \
        hwloc \
        #hwloc-devel pam-devel \
        #perl-ExtUtils-MakeMaker \
        perl python3

#source of slurm
ENV SLURM_TAR_GZ_SOURCE=https://github.com/SchedMD/slurm/archive/refs/tags/slurm-20-02-3-1.tar.gz

# volume for final deb dump
VOLUME ./docker_debian/DEB

# setup entry point
WORKDIR /root

COPY ./docker_debian/make_slurm_deb ./docker_debian/utils/cmd_setup ./docker_debian/utils/cmd_start ./docker_debian/utils/cmd_stop /usr/local/sbin/
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["make_slurm_deb"]
