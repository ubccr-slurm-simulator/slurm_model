#!/usr/bin/env bash

#/slurm_model/nano
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLUSTER_DIR="${CUR_DIR}"
SLURM_MODEL_DIR="$( dirname "${CUR_DIR}" )"
SIMULATOR_DIR="${SLURM_MODEL_DIR}/apps/simulation"

set -e

max_execution_times=4
CORE_COUNT="single_core"
APP="mulmat"
job_traces_dir="/slurm_model/nano/job_traces/jobs_single_node/job_traces_single_core.csv"
cd $CLUSTER_DIR

#mkdir -p doc/nano/single_core/
confirm_proces(){
  timeout_time=700
  confirm_sentence="All simulation has been submitted"
  echo "comfirming sentence"
  for ((i=0; i < timeout_time; i++))
    {
        if grep -Fxq "${confirm_sentence}" "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"/simulation.log; then
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
  timeout_time=50
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

for ((index=0; index<${max_execution_times}; index++))
do
./vc_start ${index}
confirm_accounting_information
  if [ "${check_account_result}" == 0 ];then
    sleep 1
    echo ${index}
    if [ ${index} == 0 ]; then
      mkdir -p ${CUR_DIR}/profile_none/doc
      RES_SAVE_DIR=${CUR_DIR}/profile_none/res
    elif [ ${index} == 1 ]; then
      mkdir -p ${CUR_DIR}/profile_10s/doc
      RES_SAVE_DIR=${CUR_DIR}/profile_10s/res
    elif [ ${index} == 2 ]; then
      mkdir -p ${CUR_DIR}/profile_20s/doc
      RES_SAVE_DIR=${CUR_DIR}/profile_20s/res
    else
      mkdir -p ${CUR_DIR}/profile_30s/doc
      RES_SAVE_DIR=${CUR_DIR}/profile_30s/res
    fi
    mkdir -p "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"

    echo "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"

    echo "Starting pmdumtext"
    pmdumptext -Xlimu -f %F\ \%T -d "," disk.partitions.write[vdb1] disk.partitions.write_bytes[vdb1] \
    disk.partitions.read[vdb1] disk.partitions.read_bytes[vdb1] filesys.used[/dev/vdb1] filesys.usedfiles[/dev/vdb1]\
    >& "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"/"profile_io.out" &

    echo "Starting simulation"
    docker exec head-node python3 -u /slurm_model/apps/simulation/simjobs.py \
    "${job_traces_dir}" >& "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"/simulation.log &

    sleep 5
    confirm_proces
    #echo "Submitted, sleep"
    #sleep 601
    if [ "${check_result}" == 0 ];then
      sleep 10
      pkill -9 pmdumptext
      sleep 2
      docker exec head-node sacct --parsable --noheader --allocations --duplicates --format jobid,jobidraw,cluster,partition,account,group,gid,user,uid,submit,eligible,start,end,elapsed,exitcode,state,nnodes,ncpus,reqcpus,reqmem,reqgres,reqtres,timelimit,nodelist,jobname \
      --starttime 2020-05-01T00:00:00 --endtime 2020-12-30T00:00:00 >& "${RES_SAVE_DIR}"/"${CORE_COUNT}"/"${APP}"/sacct.log &
      sleep 5
      ./vc_stop
    else
      echo "Something is wrong,can confirm all process has finised"
      exit 1
    fi
    else
      echo "something is wrong"
      exit 1
    fi
done
echo "All simulation has finished"