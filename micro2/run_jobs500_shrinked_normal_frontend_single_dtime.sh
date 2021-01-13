#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
pwd

normal_slurm_results_dir=jobs500_shrinked_v3
frontend_slurm_results_dir=jobs500_shrinked_frontend_v3

mkdir -p ./results/${normal_slurm_results_dir}
mkdir -p ./results/${frontend_slurm_results_dir}

echo "${normal_slurm_results_dir}"
echo "${frontend_slurm_results_dir}"

for dtstart in 10
do
    for i in {1..20}
    do
        echo "Normal Slurm: Stated modelling with dtstart ${dtstart}, i ${i}"
        docker-compose up -d
        sleep 10
        docker exec micro2_headnode_1 /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm -e /opt/cluster/micro2/etc \
                    -t /opt/cluster/micro2/job_traces/jobs500_shrinked.events \
                    -r /root/results/${normal_slurm_results_dir}/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
                    -d -v -dtstart ${dtstart} --no-slurmd &> ./results/${normal_slurm_results_dir}/dtstart_${dtstart}_${i}.log
        docker-compose stop
        docker-compose rm -f -s -v

        echo "Fronend Slurm: Stated modelling with dtstart ${dtstart}, i ${i}"
        docker run --name slurm -h slurm --rm -d -v $(pwd)/results:/root/results \
            nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld -loop
        sleep 10
        docker exec slurm /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm_front_end -e /opt/cluster/micro2/etc_frontend \
            -t /opt/cluster/micro2/job_traces/jobs500_shrinked.events \
            -r /root/results/${frontend_slurm_results_dir}/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
            -d -v -dtstart ${dtstart} &> ./results/${frontend_slurm_results_dir}/dtstart_${dtstart}_${i}.log
        docker stop slurm
    done
done
