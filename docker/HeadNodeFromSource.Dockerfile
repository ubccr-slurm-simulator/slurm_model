FROM nsimakov/slurm_common:23.11

LABEL description="HeadNode Image for Slurm Virtual Cluster"

USER root

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
        perl perl-Switch perl-ExtUtils-MakeMaker perl-Date* \
        python3 python3-PyMySQL python3-pip \
        libjwt libjwt-devel \
        glib2-devel \
        iproute && \
    dnf clean all && \
    pip install pandas psutil&& \
    rm -rf /var/cache/dnf

#configure mysqld
#FROM working
RUN chmod g+rw /var/lib/mysql /var/log/mariadb /var/run/mariadb && \
    mysql_install_db && \
    chown -R mysql:mysql /var/lib/mysql /var/log/mariadb && \
    cmd_start mysqld && \
    mysql -e 'DELETE FROM mysql.user WHERE user NOT LIKE "root";' && \
    mysql -e 'DELETE FROM mysql.user WHERE Host NOT IN ("localhost","127.0.0.1","%");' && \
    mysql -e 'DROP DATABASE IF EXISTS test;' && \
    mysql -e "CREATE USER 'slurm'@'%' IDENTIFIED BY 'slurm';" && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "slurm"@"%" WITH GRANT OPTION;' && \
    mysql -e "CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'slurm';" && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "slurm"@"localhost" WITH GRANT OPTION;' && \
    cmd_stop mysqld





# copy slurm src
COPY ./docker/slurm_src /root/slurm_src

#install Slurm
RUN cd /root/slurm_src && \
    mkdir build1 && \
    cd build1  && \
    ../configure --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
        --sysconfdir=/etc/slurm --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 \
        --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man \
        --infodir=/usr/share/info  && \
    make -j && \
    make -j install && \
    mkdir /var/log/slurm  && \
    chown -R slurm:slurm /var/log/slurm  && \
    mkdir /var/state  && \
    chown -R slurm:slurm /var/state  && \
    mkdir -p /var/spool/slurmd  && \
    chown -R slurm:slurm /var/spool/slurmd && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    touch /bin/mail  && chmod 755 /bin/mail && \
    echo '/opt/cluster/vctools/start_head_node.sh' >> /root/.bash_history

EXPOSE 6819
EXPOSE 6817
# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["-loop", "/opt/cluster/vctools/init_system", "munged", "mysqld", "slurmdbd", "slurmctld", "sshd", "/opt/cluster/vctools/init_slurm", "bash"]
