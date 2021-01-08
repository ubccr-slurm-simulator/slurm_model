#!/bin/bash

mkdir -p ./results/jobs500
echo "jobs500"

for dtstart in 10 30 50 70 90 110
do
    for i in {1..10}
    do
        echo "Stated modelling with dtstart ${dtstart}, i ${i}"
        docker-compose up -d
        sleep 10
        docker exec micro2_headnode_1 /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm -e /opt/cluster/micro2/etc \
                    -t /opt/cluster/micro2/job_traces/jobs500.events \
                    -r /root/results/jobs500/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
                    -d -v -dtstart ${dtstart} --no-slurmd &> ./results/jobs500/dtstart_${dtstart}_${i}.log
        docker-compose stop
        docker-compose rm -f -s -v
    done
done
