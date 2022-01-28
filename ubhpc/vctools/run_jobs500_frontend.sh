#!/bin/bash

mkdir -p ~/results/jobs500_frontend
echo "jobs500_frontend"

for dtstart in 10 30 50 70 90 110
do
    for i in {1..4}
    do
        echo "Stated modelling with dtstart ${dtstart}, i ${i}"
        sudo /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm_front_end -e /opt/cluster/micro2/etc_frontend \
            -t /opt/cluster/micro2/job_traces/jobs500.events \
            -r ~/results/jobs500_frontend/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
            -d -v -dtstart ${dtstart} &> ~/results/jobs500_frontend/dtstart_${dtstart}_${i}.log
    done
done
