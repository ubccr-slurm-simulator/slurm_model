#!/usr/bin/env bash

#/slurm_model/nano
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLUSTER_DIR="${CUR_DIR}"
SLURM_MODEL_DIR="$( dirname "${CUR_DIR}" )"
SIMULATOR_DIR="${SLURM_MODEL_DIR}/apps/simulation"

set -e

TIME_OUT=$1
check_result=-1
#CORE_COUNT=$1

#job_traces_dir="/slurm_model/nano/job_traces/jobs_single_node/job_traces_four_cores.csv"
cd $CLUSTER_DIR

#mkdir -p doc/nano/single_core/
confirm_proces(){
  timeout_time="${TIME_OUT}"
  confirm_sentence="All simulation has been submitted"
  echo "comfirming sentence"
  for ((i=0; i < timeout_time; i++))
    {
        if grep -Fxq simulation.log; then
          sCount=$(docker exec head-node squeue|wc -l)
          if [ ${sCount} == 1 ] ;then
            echo "confirm all jobs has been submitted,and finished"
            check_result=0
            break
          fi
        else
          check_result=1
        fi
        sleep 1
    }
}
confirm_accounting_information(){
  timeout_time=60
  echo "Comfirming accounting infromation"
  for ((i=0; i < timeout_time; i++))
    {
      sCount=$(docker exec head-node sacctmgr show account|wc -l)
      if [ ${sCount} == 6 ] ;then
        echo "Accounting is up"
        check_account_result=0
        break
      fi
      check_account_result=1
      sleep 1
    }
}

#./vc_start
confirm_accounting_information

if [ "${check_account_result}" == 0 ];then
sleep 3

echo "Starting pmdumtext"
nohup pmdumptext -Xlimu -f %F\ \%T -d "," disk.partitions.write[vdb1] disk.partitions.write_bytes[vdb1] \
disk.partitions.read[vdb1] disk.partitions.read_bytes[vdb1] filesys.used[/dev/vdb1] filesys.usedfiles[/dev/vdb1] >& profile_io.out &

echo "Starting simulation"
docker exec head-node python3 -u /slurm_model/apps/simulation/simjobs.py -t 3 /slurm_model/apps/simulation/test.csv >& simulation.log
confirm_proces

if [ "${check_result}" == 0 ];then
  sleep 90
  pkill -9 pmdumptext
  sleep 2
  docker exec head-node sacct --parsable --noheader --allocations --duplicates --format jobid,jobidraw,cluster,partition,account,group,gid,user,uid,submit,eligible,start,end,elapsed,exitcode,state,nnodes,ncpus,reqcpus,reqmem,reqgres,reqtres,timelimit,nodelist,jobname \
  --starttime 2020-05-01T00:00:00 --endtime 2020-12-30T00:00:00 >& sacct.log &
  sleep 5
  #docker cp head-node:/var/log/slurm/slurmctld.log  "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"/slurm_control.log
  ./vc_stop
else
  echo "Run time is up"
  docker exec head-node scancel -u user1
  sleep 5
  confirm_proces
  if [ "${check_result}" == 0 ];then
    sleep 90
    pkill -9 pmdumptext
    sleep 2
    docker exec head-node sacct --parsable --noheader --allocations --duplicates --format jobid,jobidraw,cluster,partition,account,group,gid,user,uid,submit,eligible,start,end,elapsed,exitcode,state,nnodes,ncpus,reqcpus,reqmem,reqgres,reqtres,timelimit,nodelist,jobname \
    --starttime 2020-05-01T00:00:00 --endtime 2020-12-30T00:00:00 >& sacct.log &
    sleep 5
  else
    echo "Something is wrong"
    exit 1
  fi
fi
else
  echo "something is wrong"
  exit 1
fi
echo "All simulation has finished"