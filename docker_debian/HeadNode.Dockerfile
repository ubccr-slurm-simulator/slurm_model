FROM pseudo/slurm_common:latest

LABEL description="HeadNode Image for Slurm Virtual Cluster"

USER root
#install dependencies
RUN \
    apt-get install -y \
        mariadb-server && \
    apt-get clean all

#configure mysqld
RUN mkdir /var/log/mariadb /var/run/mariadb && \
    chmod g+rw /var/lib/mysql /var/log/mariadb /var/run/mariadb && \
    mysql_install_db && \
    chown -R mysql:mysql /var/lib/mysql && \
    cmd_start mysqld && \
    mysql -e 'DELETE FROM mysql.user WHERE user NOT LIKE "root";' && \
    mysql -e 'DELETE FROM mysql.user WHERE Host NOT IN ("localhost","127.0.0.1","%");' && \
    mysql -e 'DROP DATABASE IF EXISTS test;' && \
    cmd_stop mysqld

#copy slurm deb
COPY ./docker_debian/DEB/slurm*.deb /root/

#copy etc (remove later)
COPY ./micro1/etc/* /etc/

#install Slurm
Run \
    dpkg-deb -x slurm*.deb dir && \
    rsync -au "./dir/usr/" "/usr" && \
    rm slurm*.deb  && \
    mkdir /var/log/slurm  && \
    chown -R slurm:slurm /var/log/slurm  && \
    mkdir /var/state  && \
    chown -R slurm:slurm /var/state  && \
    mkdir -p /var/spool/slurmd  && \
    chown -R slurm:slurm /var/spool/slurmd

EXPOSE 29002

# setup entry point
ENTRYPOINT ["/usr/local/sbin/cmd_start"]
CMD ["-loop", "/vctools/init_system", "munged", "mysqld", "slurmdbd", "slurmctld", "sshd", "/vctools/init_slurm", "bash"]
