#!/usr/bin/env bash
export SLURM_HOME=/opt/slurm
export SLURM_CONF=/opt/cluster/micro2/etc/slurm.conf
export PATH=${SLURM_HOME}/sbin:${SLURM_HOME}/bin:${PATH}

echo "Dropping slurmdb_micro2 DB"
mysql -u root << END
drop database if exists slurmdb_micro2;
END

echo "Starting slurmdbd"
slurmdbd

sleep 5

echo "Running sacctmgr"
set +e
sacctmgr -i < /opt/cluster/micro2/utils/sacctmgr.script
set -e

sleep 5

echo "Starting slurmctld"
slurmctld

ps -Af
