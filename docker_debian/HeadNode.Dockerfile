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
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;' && \
    mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;' && \
    mysql -e 'DROP DATABASE IF EXISTS test;' && \
    cmd_stop mysqld
