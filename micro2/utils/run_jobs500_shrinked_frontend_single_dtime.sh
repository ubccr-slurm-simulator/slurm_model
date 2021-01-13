#!/bin/bash

mkdir -p ~/results/jobs500_shrinked_frontend_single_dtime
echo "jobs500_shrinked_frontend_single_dtime"

for dtstart in 10
do
    for i in {1..20}
    do
        echo "Stated modelling with dtstart ${dtstart}, i ${i}"
        sudo /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm_front_end -e /opt/cluster/micro2/etc_frontend \
            -t /opt/cluster/micro2/job_traces/jobs500_shrinked.events \
            -r ~/results/jobs500_shrinked_frontend_single_dtime/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
            -d -v -dtstart ${dtstart} &> ~/results/jobs500_shrinked_frontend_single_dtime/dtstart_${dtstart}_${i}.log
    done
done
