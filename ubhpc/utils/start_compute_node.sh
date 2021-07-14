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

echo "Starting slurmd"
slurmd
