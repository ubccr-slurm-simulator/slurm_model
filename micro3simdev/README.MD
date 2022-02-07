This directory contain docker compose file for Slurm Simulator Development


```bash
docker compose up -d
docker exec -it micro3simdev-headnode-1 /bin/bash


echo "Dropping slurmdb_micro3 DB"
mysql -u root << END
drop database if exists slurmdb_micro3;
END

echo "Starting slurmdbd"
slurmdbd

sleep 10
echo "Running sacctmgr"
set +e
sacctmgr -i -p < /opt/cluster/vctools/sacctmgr.script
set -e


mkdir bld
cd ~/bld
rm -rf *
/opt/cluster/slurm_sim_tools/slurm_simulator/configure \
    --prefix=/usr  --sysconfdir=/etc/slurm --disable-x11 \
    --with-hdf5=no --enable-simulator
make -j
make -j install

slurmctld -v -e /opt/cluster/job_traces/small.events

mkdir ~/bld_deb
cd ~/bld_deb
rm -rf *
/opt/cluster/slurm_sim_tools/slurm_simulator/configure \
    --prefix=/usr  --sysconfdir=/etc/slurm --disable-x11 \
    --with-hdf5=no --enable-simulator --enable-debug --enable-front-end \
    "CFLAGS=-g -O0"
make -j
make -j install


 2204  sudo apt install libmunge-dev
 2209  sudo apt install libmysqlclient-dev


CREATE USER 'slurm'@'%' IDENTIFIED BY 'slurm';
CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'slurm';

GRANT ALL PRIVILEGES ON *.* TO 'slurm'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'slurm'@'%' WITH GRANT OPTION;

```

# run sim

```
docker run -it --rm -h headnode --name slurm_sim_head_node \
      -v `pwd`/results:/root/results \
      -v `pwd`/etc:/etc/slurm \
      -v `pwd`/../micro3/vctools:/opt/cluster/vctools \
      -v `pwd`/../micro3/job_traces:/opt/cluster/job_traces \
      -v `pwd`/log:/var/log/slurm \
      -v `pwd`/home:/home \
      -v `pwd`/../../slurm_sim_tools:/opt/cluster/slurm_sim_tools \
      -p 5000:5000 -p 2222:22 \
    nsimakov/slurm_sim_head_node:4
ssh -nNT -L 5001:localhost:5000 -p 2222 root@localhost

```

```
[root@headnode bld]# ldd /usr/sbin/slurmctld
        linux-vdso.so.1 =>  (0x00007fffd7d3c000)
        libslurmfull.so => /usr/lib/slurm/libslurmfull.so (0x00007f083d760000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f083d55c000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f083d342000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f083d13a000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f083ce38000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f083cc1c000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f083c84e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f083db39000)
[root@headnode bld]# /opt/cluster/
job_traces/      microapps/       slurm_sim_tools/ vctools/         
[root@headnode bld]# /opt/cluster/slurm_sim_tools/
bin/             developing/      docker/          .idea/           .pytest_cache/   slurm_simulator/ tests/           tmp/             ubccr/
build/           doc/             .git/            miniapps/        reg_testing/     src/             tmo/             tutorials/       
[root@headnode bld]# md5sum /usr/sbin/slurmctld
5781c0afdcc2df6cdbb216e261210f81  /usr/sbin/slurmctld
[root@headnode bld]# md5sum /usr/lib/slurm/libslurmfull.so
0f5145fe400c7591846f256b0c86c5e0  /usr/lib/slurm/libslurmfull.so
[root@headnode bld]# 
```

-dt 2 -e submit_batch_job | -J jobid_1003 -sim-walltime 5 --uid=user4 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account2 -p normal -q normal --mem=500000 pseudo.job
-dt 19 -e submit_batch_job | -J jobid_1005 -sim-walltime 2 --uid=user5 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --mem=500000 pseudo.job
-dt 29 -e submit_batch_job | -J jobid_1011 -sim-walltime 0 --uid=user4 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account2 -p normal -q normal --gres=gpu:1 pseudo.job
-dt 36 -e submit_batch_job | -J jobid_1013 -sim-walltime 0 --uid=user2 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account1 -p normal -q normal --mem=500000 pseudo.job
-dt 40 -e submit_batch_job | -J jobid_1016 -sim-walltime 25 --uid=user1 -t 00:01:00 -n 2 --ntasks-per-node=2 -A account1 -p normal -q normal --gres=gpu:2 pseudo.job
-dt 43 -e submit_batch_job | -J jobid_1019 -sim-walltime 34 --uid=user4 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --gres=gpu:2 pseudo.job

-dt 0 -e submit_batch_job | -J jobid_1001 -sim-walltime 0 --uid=user5 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal pseudo.job
-dt 1 -e submit_batch_job | -J jobid_1002 -sim-walltime -1 --uid=user1 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account1 -p normal -q normal --constraint=CPU-N pseudo.job
-dt 2 -e submit_batch_job | -J jobid_1003 -sim-walltime 5 --uid=user4 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account2 -p normal -q normal --mem=500000 pseudo.job
-dt 16 -e submit_batch_job | -J jobid_1004 -sim-walltime 21 --uid=user3 -t 00:01:00 -n 24 --ntasks-per-node=12 -A account1 -p normal -q normal pseudo.job
-dt 19 -e submit_batch_job | -J jobid_1005 -sim-walltime 2 --uid=user5 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --mem=500000 pseudo.job
-dt 19 -e submit_batch_job | -J jobid_1006 -sim-walltime 9 --uid=user3 -t 00:01:00 -n 48 --ntasks-per-node=12 -A account1 -p normal -q normal pseudo.job
-dt 19 -e submit_batch_job | -J jobid_1007 -sim-walltime -1 --uid=user4 -t 00:01:00 -n 24 --ntasks-per-node=12 -A account2 -p normal -q normal --constraint=CPU-M pseudo.job
-dt 22 -e submit_batch_job | -J jobid_1008 -sim-walltime 0 --uid=user4 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --constraint=CPU-M pseudo.job
-dt 26 -e submit_batch_job | -J jobid_1009 -sim-walltime 2 --uid=user1 -t 00:01:00 -n 96 --ntasks-per-node=12 -A account1 -p normal -q normal pseudo.job
-dt 26 -e submit_batch_job | -J jobid_1010 -sim-walltime 0 --uid=user5 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --constraint=CPU-N pseudo.job
-dt 29 -e submit_batch_job | -J jobid_1011 -sim-walltime 0 --uid=user4 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account2 -p normal -q normal --gres=gpu:1 pseudo.job
-dt 32 -e submit_batch_job | -J jobid_1012 -sim-walltime -1 --uid=user5 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account2 -p normal -q normal pseudo.job
-dt 36 -e submit_batch_job | -J jobid_1013 -sim-walltime 0 --uid=user2 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account1 -p normal -q normal --mem=500000 pseudo.job
-dt 36 -e submit_batch_job | -J jobid_1014 -sim-walltime 7 --uid=user5 -t 00:01:00 -n 24 --ntasks-per-node=12 -A account2 -p normal -q normal --constraint=CPU-N pseudo.job
-dt 39 -e submit_batch_job | -J jobid_1015 -sim-walltime 18 --uid=user2 -t 00:01:00 -n 6 --ntasks-per-node=6 -A account1 -p normal -q normal pseudo.job
-dt 40 -e submit_batch_job | -J jobid_1016 -sim-walltime 25 --uid=user1 -t 00:01:00 -n 2 --ntasks-per-node=2 -A account1 -p normal -q normal --gres=gpu:2 pseudo.job
-dt 42 -e submit_batch_job | -J jobid_1017 -sim-walltime 1 --uid=user1 -t 00:01:00 -n 48 --ntasks-per-node=12 -A account1 -p normal -q normal --constraint=CPU-N pseudo.job
-dt 42 -e submit_batch_job | -J jobid_1018 -sim-walltime 0 --uid=user3 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account1 -p normal -q normal pseudo.job
-dt 43 -e submit_batch_job | -J jobid_1019 -sim-walltime 34 --uid=user4 -t 00:01:00 -n 12 --ntasks-per-node=12 -A account2 -p normal -q normal --gres=gpu:2 pseudo.job
-dt 43 -e submit_batch_job | -J jobid_1020 -sim-walltime 14 --uid=user1 -t 00:01:00 -n 1 --ntasks-per-node=1 -A account1 -p normal -q normal --constraint=CPU-N pseudo.job


slurmctld: debug2: priority/multifactor: priority_p_set: initial priority for job 1000 is 1017976
slurmctld: debug2: _build_node_list: JobId=1000 filtered all nodes (n[1-4]): Memory specification can not be satisfied
slurmctld: debug2: _build_node_list: JobId=1000 filtered all nodes (m[1-4]): Memory specification can not be satisfied
slurmctld: debug2: _build_node_list: JobId=1000 filtered all nodes (g1): Memory specification can not be satisfied
slurmctld: debug2: found 1 usable nodes from config containing b1
slurmctld: debug3: _pick_best_nodes: JobId=1000 idle_nodes 10 share_nodes 10
slurmctld: debug2: select/cons_res: select_p_job_test: select_p_job_test for JobId=1000
slurmctld: debug2: select/cons_res: select_p_job_test: select_p_job_test for JobId=1000
slurmctld: debug2: select/cons_res: select_p_job_test: select_p_job_test for JobId=1000
slurmctld: _pick_best_nodes: JobId=1000 never runnable in partition normal

[2022-01-31T18:37:28.651662] debug2: priority/multifactor: priority_p_set: initial priority for job 1002 is 1060833
[2022-01-31T18:37:28.651683] debug2: _build_node_list: JobId=1002 filtered all nodes (n[1-4]): Memory specification can not be satisfied
[2022-01-31T18:37:28.651695] debug2: _build_node_list: JobId=1002 filtered all nodes (m[1-4]): Memory specification can not be satisfied
[2022-01-31T18:37:28.651707] debug2: _build_node_list: JobId=1002 filtered all nodes (g1): Memory specification can not be satisfied
[2022-01-31T18:37:28.651720] debug2: found 1 usable nodes from config containing b1
[2022-01-31T18:37:28.651737] debug3: _pick_best_nodes: JobId=1002 idle_nodes 10 share_nodes 10
[2022-01-31T18:37:28.651750] debug2: select/cons_res: select_p_job_test: select_p_job_test for JobId=1002
[2022-01-31T18:37:28.651773] debug2: sched: JobId=1002 allocated resources: NodeList=(null)
[2022-01-31T18:37:28.651784] _slurm_rpc_submit_batch_job: JobId=1002 InitPrio=1060833 usec=302
[2022-01-31T18:37:28.818578] sched/backfill: _attempt_backfill: beginning
[2022-01-31T18:37:28.818602] debug:  sched/backfill: _attempt_backfill: 2 jobs to backfill
