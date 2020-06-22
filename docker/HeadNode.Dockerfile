FROM pseudo/slurm_common:latest

LABEL description="HeadNode Image for Slurm Virtual Cluster"

# install dependencies
RUN \
    yum -y install --setopt=tsflags=nodocs \
        mariadb-server && \
    yum clean all

#configure mysqld
RUN chmod g+rw /var/lib/mysql /var/log/mariadb /var/run/mariadb && \
    mysql_install_db && \
    chown -R mysql:mysql /var/lib/mysql && \
    cmd_start mysqld && \
    mysql -e 'DELETE FROM mysql.user WHERE user NOT LIKE "root";' && \
    mysql -e 'DELETE FROM mysql.user WHERE Host NOT IN ("localhost","127.0.0.1","%");' && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;' && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;' && \
    mysql -e 'DROP DATABASE IF EXISTS test;' && \
    cmd_stop mysqld

# copy slurm rpm
COPY ./docker/RPMS/x86_64/slurm*.rpm /root/
COPY ./micro1/bin/init_system /sbin/init_system

#install Slurm
RUN yum -y install \
        slurm-[0-9]*.x86_64.rpm \
        slurm-perlapi-*.x86_64.rpm \
        slurm-slurmctld-*.x86_64.rpm \
        slurm-slurmdbd-*.x86_64.rpm  \
        slurm-pam_slurm-*.x86_64.rpm && \
    rm slurm*.rpm  && \
    mkdir /var/log/slurm  && \
    chown -R slurm:slurm /var/log/slurm  && \
    mkdir /var/state  && \
    chown -R slurm:slurm /var/state  && \
    mkdir -p /var/spool/slurmd  && \
    chown -R slurm:slurm /var/spool/slurmd

EXPOSE 29002

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["-loop", "munged", "mysqld", "slurmdbd", "slurmctld", "sshd", "bash"]
