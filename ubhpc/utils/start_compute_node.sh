#!/usr/bin/env bash
export SLURM_HOME=/opt/slurm
export SLURM_CONF=/opt/cluster/ubhpc/etc/slurm.conf
export PATH=${SLURM_HOME}/sbin:${SLURM_HOME}/bin:${PATH}

echo "Starting slurmd"
slurmd
