#!/usr/bin/env bash
export SLURM_HOME=/opt/slurm
export SLURM_CONF=/opt/cluster/ubhpc/etc/slurm.conf
export PATH=${SLURM_HOME}/sbin:${SLURM_HOME}/bin:${PATH}


mkdir -p /opt/cluster/ubhpc/run /opt/cluster/ubhpc/log
mkdir -p /opt/cluster/ubhpc/var/spool /opt/cluster/ubhpc/var/state
chown -R slurm:slurm /opt/cluster
chmod 755 /opt/cluster /opt/cluster/ubhpc /opt/cluster/ubhpc/var
chmod 700 /opt/cluster/ubhpc/var/spool /opt/cluster/ubhpc/var/state
chown -R slurm:slurm /opt

echo "Dropping slurmdb_ubhpc DB"
mysql -u root << END
drop database if exists slurmdb_ubhpc;
END

echo "Starting slurmdbd"
slurmdbd
echo "Starting slurmctld"
slurmctld

sleep 10
echo "Running sacctmgr"
set +e
sacctmgr -i < /opt/cluster/ubhpc/utils/sacctmgr.script
set -e

ps -Af
