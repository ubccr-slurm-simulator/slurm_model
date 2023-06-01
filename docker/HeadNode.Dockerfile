FROM nsimakov/slurm_common:23.11

LABEL description="HeadNode Image for Slurm Virtual Cluster"

USER root
# install dependencies
RUN dnf update --assumeno || true && \
    dnf -y install 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled crb && \
    dnf -y install --setopt=tsflags=nodocs \
        vim tmux mc perl-Switch \
        iproute perl-Date* \
        python3 python3-PyMySQL python3-pip \
        mariadb-server && \
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

# copy slurm rpm
COPY ./docker/RPMS/x86_64/slurm*.rpm /root/

#install Slurm
RUN dnf update --assumeno || true && \
    dnf -y install \
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
