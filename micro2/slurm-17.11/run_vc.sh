#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
pwd

jobs_basename=jobs500
sim_suffix=v4

#dtstart_list="10 30 50 70 90 110"
#run_ids=$(seq 1 4)
dtstart_list=20
run_ids=1

run_normal=0
run_frontend=0
run_sim=0

nodes_prefix=slurm-1711

while (( "$#" ))
do
    case "$1" in
    -jb)
        shift
        jobs_basename=$1
        ;;
    -s)
        shift
        sim_suffix=$1
        ;;
    -run-ids)
        shift
        run_ids=$1
        ;;
    -dtstart)
        shift
        dtstart_list=$1
        ;;
    -normal)
        run_normal=1
        ;;
    -frontend)
        run_frontend=1
        ;;
    -sim)
        run_sim=1
        ;;
    -h)
        echo "Usage:"
        echo "./run_normal_frontend.sh -jb <jobs_basename> -simsuf <sim_suffix> \\"
        echo "        -dtstart <list of dt start> -run-ids <list of run-ids> \\"
        echo "        [-normal] [-frontend]"
        exit 0
        ;;
    *)
        echo "Unknown argument $1"
        ;;
    esac
    shift
done

echo "jobs_basename: ${jobs_basename}"
echo "sim_suffix: ${sim_suffix}"
echo "dtstart_list: ${dtstart_list}"
echo "run_ids: ${run_ids}"

job_traces=${jobs_basename}.events
normal_slurm_results_dir=${jobs_basename}_normal_${sim_suffix}
frontend_slurm_results_dir=${jobs_basename}_frontend_${sim_suffix}
sim_slurm_results_dir=${jobs_basename}_sim_${sim_suffix}

echo "job_traces: ${job_traces}"

if [[ "${run_normal}" == "1" ]]; then
    echo "normal_slurm_results_dir: ${normal_slurm_results_dir}"
    mkdir -p ./results/${normal_slurm_results_dir}
fi
if [[ "${run_frontend}" == "1" ]]; then
    echo "frontend_slurm_results_dir: ${frontend_slurm_results_dir}"
    mkdir -p ./results/${frontend_slurm_results_dir}
fi
if [[ "${run_sim}" == "1" ]]; then
    echo "sim_slurm_results_dir: ${sim_slurm_results_dir}"
    mkdir -p ./results/${sim_slurm_results_dir}
fi


for dtstart in ${dtstart_list}
do
    for i in ${run_ids}
    do
        if [[ "${run_normal}" == "1" ]]; then
            echo "Normal Slurm: Stated modelling with dtstart ${dtstart}, i ${i}"
            docker-compose up -d
            sleep 10
            docker exec ${nodes_prefix}_headnode_1 /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm -e /opt/cluster/micro2/etc \
                        -t /opt/cluster/micro2/job_traces/${job_traces} \
                        -r /root/results/${normal_slurm_results_dir}/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
                        -d -v -dtstart ${dtstart} --no-slurmd &> ./results/${normal_slurm_results_dir}/dtstart_${dtstart}_${i}.log
            docker-compose stop
            docker-compose rm -f -s -v
        fi

        if [[ "${run_frontend}" == "1" ]]; then
            echo "Fronend Slurm: Stated modelling with dtstart ${dtstart}, i ${i}"
            docker run --name slurm -h slurm --rm -d -v $(pwd)/results:/root/results \
                nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld -loop
            sleep 10
            docker exec slurm /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm_front_end -e /opt/cluster/micro2/etc_frontend \
                -t /opt/cluster/micro2/job_traces/${job_traces} \
                -r /root/results/${frontend_slurm_results_dir}/dtstart_${dtstart}_${i} -a /opt/cluster/micro2/utils/sacctmgr.script \
                -d -v -dtstart ${dtstart} &> ./results/${frontend_slurm_results_dir}/dtstart_${dtstart}_${i}.log
            docker stop slurm
        fi

        if [[ "${run_sim}" == "1" ]]; then
            echo "Slurm-Sim: Stated modelling with dtstart ${dtstart}, i ${i}"

            ${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
                -s ${HOME}/slurm_sim_ws/slurm_sim \
                -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
                -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/${job_traces} \
                -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/${sim_slurm_results_dir}/dtstart_${dtstart}_${i} \
                -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
                -d -v -dtstart ${dtstart} --ignore-errors-in-conf -octld c.log
        fi
    done
done

docker network rm ${nodes_prefix}_network1
