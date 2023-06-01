Micro2 is small cluster used for validation of simulator.

This directory contains files used for generation of reference job history.

# Host Preparation

Install docker and docker compose

```bash
# Install dependencies
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# Add Docker Repo
sudo yum-config-manager \
    --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Start Docker
sudo systemctl start docker

# Set it to start on boot
sudo systemctl enable docker

# Verify that docker is working
sudo docker run hello-world

# add centos user to docker group
sudo usermod -aG docker centos

# install docker compose version 2.1 +
# sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
cd /usr/libexec/docker/cli-plugins/
# or /usr/lib/docker/cli-plugins OR /usr/libexec/docker/cli-plugins
sudo wget https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 docker-compose
sudo chmod 755 docker-compose

# exit and re-loging for new group to work
exit
```
# Building Docker Container


```bash
# Working in root of repo
# Using Slurm simulator repository:
docker build -f ./micro2/SlurmVC_SimRepo.Dockerfile -t nsimakov/slurm_vc:slurm-20.02-sim .
```

# Running Virtual Cluster

Manually run one simulation
```bash
cd micro2
docker-compose up -d
sleep 10
docker exec -it micro2_headnode_1 /opt/slurm_sim_tools/src/run_slurm.py -s /opt/slurm -e /opt/cluster/micro2/etc \
            -t /opt/cluster/micro2/job_traces/jobs500_shrinked.events \
            -r /root/results/jobs500_shrinked/dtstart_10_1 -a /opt/cluster/micro2/utils/sacctmgr.script \
            -d -v -dtstart 10 --no-slurmd
docker-compose stop
docker-compose rm -f -s -v
```

Run number of simulation
```bash
# Run shrinked jobs500
cd micro2
./run_jobs500_shrinked.sh
# Run jobs500
cd micro2
./run_jobs500.sh
```

Simulator
```bash
${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
    -s ${HOME}/slurm_sim_ws/slurm_sim_deb \
    -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
    -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/jobs500_shrinked.events \
    -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/jobs500_shrinked_sim/dtstart_10_1 \
    -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
    -d -v -dtstart 10 

for i in {1..10}
do
    ${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
        -s ${HOME}/slurm_sim_ws/slurm_sim_deb \
        -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
        -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/jobs500_shrinked.events \
        -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/jobs500_shrinked_sim_speed5/dtstart_10_${i} \
        -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
        -d -v -dtstart 10 --ignore-errors-in-conf
done

for i in {1..1}
do
    ${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
        -s ${HOME}/slurm_sim_ws/slurm_sim \
        -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
        -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/jobs500_shrinked.events \
        -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/jobs500_shrinked_sim_v1_speed1/dtstart_10_${i} \
        -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
        -d -v -dtstart 10 --ignore-errors-in-conf
done


./run_vc.sh -jb small2 -s v1 -dtstart "10" -run-ids "$(seq 1 10) -normal -frontend"

for i in {1..4}
do
    ${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
        -s ${HOME}/slurm_sim_ws/slurm_sim \
        -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
        -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/small2.events \
        -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/small2_sim_v2_speed1/dtstart_10_${i} \
        -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
        -d -v -dtstart 10 --ignore-errors-in-conf
done

${HOME}/slurm_sim_ws/slurm_sim_tools/src/run_sim.py \
        -s ${HOME}/slurm_sim_ws/slurm_sim \
        -e ${HOME}/slurm_sim_ws/slurm_model/micro2/etc_sim \
        -t ${HOME}/slurm_sim_ws/slurm_model/micro2/job_traces/small2.events \
        -r ${HOME}/slurm_sim_ws/slurm_model/micro2/results/small2_sim_v1_speed1/dtstart_10_1 \
        -a ${HOME}/slurm_sim_ws/slurm_model/micro2/utils/sacctmgr.script \
        -d -v -dtstart 10 --ignore-errors-in-conf

```


# on time

Tue 12 Jan 2021 09:58:59 AM EST


/opt/cluster/vctools/start_head_node.sh

sudo su user001
cd
sbatch -J reg1core -q general-compute -N 1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 1 -n 40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J bigmem -q general-compute -N 1 -n 40 -t 15:00 --mem=512G /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 --gres=gpu:1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu2 -q general-compute -N 1 -n 2 --gres=gpu:2 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 --gres=gpu:1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg8cores -q general-compute -N 1 -n 8 -t 15:00 /usr/local/microapps/sleep.job 300

sbatch -J reg1core -q general-compute -N 1 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 4 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 8 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1core -q general-compute -N 1 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 4 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 8 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300

sbatch -J gpu4 -q general-compute -N 2 -n 4 --gres=gpu:4 -t 15:00 /usr/local/microapps/sleep.job 300

sudo su user017
cd

sbatch -J reg1core -q supporters -N 1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1core -q priority -N 1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1core -q general-compute -N 1 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q priority-supporters -N 2 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1core -q debug -N 1 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300



sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=40 --constraint=CPU-Gold-6230 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=32 --constraint=CPU-Gold-6130 -t 15:00 /usr/local/microapps/sleep.job 300

sbatch -J gpu4 -q general-compute -N 2 --ntasks-per-node=40 --gres=gpu:2 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu16 -q general-compute -N 8 --ntasks-per-node=40 --gres=gpu:2 -t 15:00 /usr/local/microapps/sleep.job 300

add QOS Name=general-compute Priority=0 MaxSubmitJobsPerUser=1000
add QOS Name=supporters Priority=200 MaxSubmitJobsPerUser=1000
add QOS Name=priority Priority=200 MaxSubmitJobsPerUser=1000
add QOS Name=priority-supporters Priority=400 MaxSubmitJobsPerUser=1000
add QOS Name=debug Priority=0 MaxSubmitJobsPerUser=4

/opt/cluster/slurm_sim_tools/src/slurmsimtools/run_slurm.py -s /usr -e /etc/slurm \
            -t /opt/cluster/vctools/test.events \
            -r /root/results/test/dtstart_10_1 -a /opt/cluster/vctools/sacctmgr.script \
            -d -v -dtstart 10 --no-slurmd



nohup /opt/cluster/slurm_sim_tools/src/slurmsimtools/run_slurm.py -s /usr -e /etc/slurm \
            -t /opt/cluster/vctools/workload_short.events \
            -r /root/results/test/dtstart_10_1 -a /opt/cluster/vctools/sacctmgr.script \
            -d -v -dtstart 10 --no-slurmd >& out &

nohup docker exec -it ubhpc-headnode-1 /opt/cluster/slurm_sim_tools/src/slurmsimtools/run_slurm.py -s /usr -e /etc/slurm \
            -t /opt/cluster/vctools/workload_short.events \
            -r /root/results/test/dtstart_10_1 -a /opt/cluster/vctools/sacctmgr.script \
            -d -v -dtstart 10 --no-slurmd >& out &

# conf notes
sbatch -J gpu2 -q general-compute -N 1 -n 2 -G 2 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 -G 1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 -G 1 -t 15:00 /usr/local/microapps/sleep.job 300
```
# if host is different from compute nodes set:
SlurmdParameters=config_overrides
# dont do proctrack/cgroup
ProctrackType=proctrack/linuxproc
```

jobs needed to be submited from accessible place from all nodes as well as writable

~62GB of storage

## Preparing cloud instance


Now on instance install docker (see https://docs.docker.com/install/linux/docker-ce/centos/ for more details):
```bash
sudo yum -y install wget git mc vim
sudo yum -y install epel-release
sudo yum -y install zstd

# Install dependencies
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# Add Docker Repo
sudo yum-config-manager \
    --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Start Docker
sudo systemctl start docker

# Set it to start on boot
sudo systemctl enable docker

# Verify that docker is working
sudo docker run hello-world

# add centos user to docker group
sudo usermod -aG docker centos

# exit and re-loging for new group to work
exit
```
```bash
ssh -i <ssh identiry for cloud> centos@199.109.112.7

# test that docker can be executed as centos user
docker run hello-world

# install docker compose version 2.1 +
# sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
cd /usr/libexec/docker/cli-plugins/
# or /usr/lib/docker/cli-plugins OR /usr/libexec/docker/cli-plugins
sudo wget https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 docker-compose
sudo chmod 755 docker-compose



docker pull nsimakov/slurm_head_node:2
docker pull nsimakov/slurm_compute_node:2

```
# installing pcp

```bash
sudo vim /etc/yum.repos.d/performancecopilot.repo
sudo dnf install pcp-zeroconf
sudo yum install -y dnf
sudo dnf install -y pcp-zeroconf
pcp
sudo chkconfig pmcd on
sudo reboot

pcp
pmlogger
pmrep
pmval -a /var/log/pcp/pmlogger/slurm-sim-1.novalocal/20211206.21.44
systemctl status pmlogger

# uncomment and add -k 365 to keep logs for a year
sudo vi /etc/sysconfig/pmlogger_timers
# PMLOGGER_DAILY_PARAMS="-k 365"


```
...

If everything fine now we can terminate instance
```bash
openstack server stop aktest
# ensure that it shut off
openstack server list --name aktest
openstack server delete aktest
```
# starting simulation
```bash
cd /home/centos/slurm_sim_ws/slurm_model/ubhpc
./start_sim_bg 7
# check that all containers are up.
tail -f out_7

# if you see message "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?"
# then it is not
# alternatively, manually start all containers:
# edit start_sim_bg comment rm log and docker compose up -d
docker compose stop;docker compose rm -f -s -v
sudo rm log/*;sudo rm -rf compute_nodes_log/* ./home/*
# run docker compose up -d untill all up
docker compose up -d --wait --quiet-pull

./start_sim_bg 5

#also check that it start submitting the jobs

# or do separately
# ensure 
ps -Af|grep useradd
ps -Af|grep slurmd|wc -l
 docker exec -it ubhpc-headnode-1 sinfo
```
# zstd hints
```bash
# to decompress:
# tar --zstd -cf home.tar.zst home
# ZSTD_CLEVEL=19 ZSTD_NBTHREADS=8 tar --use-compress-program zstd -cf home.tar.zst home
# to decompress:
# tar -I zstd -xvf home.tar.zst
# tar --zstd -xf directory.tar.zst
```


# after simulation is done, packing it for moving
update
```
sudo yum -y install epel-release
sudo yum -y install zstd
sudo vi /etc/sysconfig/pmlogger_timers
PMLOGGER_DAILY_PARAMS="-k 365"
```

```bash
cd /home/centos/slurm_sim_ws/slurm_model/ubhpc
# make directory for a package:
# openstac name / my reference
# centos@slurm-sim-1-2 / slurm-sim-1
VC_SIM_DIR=1
RESULTS_DIR=results/test/dtstart_55_1 
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim-1-2.novalocal

# centos@slurm-sim--1 / slurm-sim-2
VC_SIM_DIR=2
RESULTS_DIR=results/test/dtstart_137_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--1.novalocal

# centos@slurm-sim--2 / slurm-sim-3
VC_SIM_DIR=3
RESULTS_DIR=results/test/dtstart_37_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--2.novalocal

# centos@slurm-sim--3 / slurm-sim-4
VC_SIM_DIR=4
RESULTS_DIR=results/test/dtstart_232_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--3.novalocal

# centos@slurm-sim--4 / slurm-sim-5
VC_SIM_DIR=5
RESULTS_DIR=results/test/dtstart_234_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--4.novalocal

# centos@slurm-sim--1 / slurm-sim-2
VC_SIM_DIR=7
RESULTS_DIR=results/test/dtstart_79_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--1.novalocal
# is not completed

[2022-01-12 03:11:30,504]-[INFO]: slurm.conf: /etc/slurm/slurm.conf
[2022-01-12 03:11:30,504]-[INFO]: slurmdbd: /usr/sbin/slurmdbd
[2022-01-12 03:11:30,504]-[INFO]: slurmd: /usr/sbin/slurmd
[2022-01-12 03:11:30,504]-[INFO]: slurmctld: /usr/sbin/slurmctld

[2022-01-17 23:48:52,788]-[INFO]: Done

# centos@slurm-sim--1-2 / slurm-sim-1-2
VC_SIM_DIR=6
RESULTS_DIR=results/test/dtstart_49_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim-1-2.novalocal

2022-01-11T22:17:37.548
2022-02-10T10:02:52.207

# centos@slurm-sim--2 / slurm-sim-3
VC_SIM_DIR=8
RESULTS_DIR=results/test/dtstart_241_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--2.novalocal

[2022-01-12T03:39:07.115]
[2022-02-10T13:53:40.221]
29678 results/test/dtstart_241_1/slurm_acct.out


# centos@slurm-sim--3 / slurm-sim-4
VC_SIM_DIR=9
RESULTS_DIR=results/test/dtstart_71_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--3.novalocal

[2022-01-12T03:41:46.846] error: Unable to open pidfile `/var/run/slurmctld.pid': Permission denied
[2022-01-12T03:41:46.846] Not running as root. Can't drop supplementary groups
[centos@slurm-sim--3 ubhpc]$ tail -n 2 $RESULTS_DIR/slurmctld.log
[2022-02-10T00:48:07.139] _job_complete: JobId=22794 done
[2022-02-10T13:57:49.920] Time limit exhausted for JobId=22810
[centos@slurm-sim--3 ubhpc]$ wc -l $RESULTS_DIR/slurm_acct.out
29678 results/test/dtstart_71_1/slurm_acct.out

# centos@slurm-sim--4 / slurm-sim-5
VC_SIM_DIR=10
RESULTS_DIR=results/test/dtstart_261_1
PCP_LOG=/var/log/pcp/pmlogger/slurm-sim--4.novalocal

[2022-01-12T03:40:23.407] error: Unable to open pidfile `/var/run/slurmctld.pid': Permission denied
[2022-01-12T03:40:23.408] Not running as root. Can't drop supplementary groups
[centos@slurm-sim--4 ubhpc]$ tail -n 2 $RESULTS_DIR/slurmctld.log
[2022-02-10T15:34:47.259] error: _handle_assoc_tres_run_secs: job 22810: assoc 1 TRES node grp_used_tres_run_secs underflow, tried to remove 248 seconds when only 0 remained.
[2022-02-10T15:34:47.259] error: _handle_assoc_tres_run_secs: job 22810: assoc 1 TRES billing grp_used_tres_run_secs underflow, tried to remove 9920 seconds when only 8120 remained.
[centos@slurm-sim--4 ubhpc]$ wc -l $RESULTS_DIR/slurm_acct.out
29678 results/test/dtstart_261_1/slurm_acct.out


# "script"
cd slurm_sim_ws/slurm_model/ubhpc/
sudo chown -R centos:centos *
head -n 2 $RESULTS_DIR/slurmctld.log
tail -n 2 $RESULTS_DIR/slurmctld.log
wc -l $RESULTS_DIR/slurm_acct.out

mkdir vc_sim_${VC_SIM_DIR}
# change permissions
sudo chown -R centos:centos *

# archive dirs just in case
ZSTD_CLEVEL=19 ZSTD_NBTHREADS=8 tar --use-compress-program zstd -cf home.tar.zst home
ZSTD_CLEVEL=19 ZSTD_NBTHREADS=8 tar --use-compress-program zstd -cf compute_nodes_log.tar.zst compute_nodes_log
ZSTD_CLEVEL=19 ZSTD_NBTHREADS=8 tar --use-compress-program zstd -cf etc.tar.zst etc

# rename vc simulation output and compress
mv out_${VC_SIM_DIR} vc_sim.out
zstd -19 -T8 vc_sim.out

zstd -19 -T8 ${RESULTS_DIR}/*

mv home.tar.zst compute_nodes_log.tar.zst etc.tar.zst vc_sim.out.zst ${RESULTS_DIR}/*.zst vc_sim_${VC_SIM_DIR}

# pcp
cp -r ${PCP_LOG} vc_sim_${VC_SIM_DIR}/pmlog

# record some details
echo '```' > vc_sim_${VC_SIM_DIR}/README.md
echo "result_dir=$RESULTS_DIR" >> vc_sim_${VC_SIM_DIR}/README.md
echo "hostname=`hostname`" >> vc_sim_${VC_SIM_DIR}/README.md
echo "# lscpu" >> vc_sim_${VC_SIM_DIR}/README.md
echo "`lscpu`" >> vc_sim_${VC_SIM_DIR}/README.md
echo '```' >> vc_sim_${VC_SIM_DIR}/README.md

```
vc-sim-1
started on 2021-12-10 ~14:00
[2022-01-09 00:08:44,249]-[INFO]: slurmctld took 705.8171768161985 hours to run.
ended on 2022-01-09 ~00:09:00


# Prep for next round
```bash
# remove all containers
docker rm -f $(docker ps -a -q)
sudo rm -rf home/* compute_nodes_log/* log/* results/*
sudo rm -rf 202112*
sudo rm -rf 2022010*
sudo rm -rf 20220110*
# reboot or not for clean sart
sudo reboot
```


rsync -a slurm-sim-2:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_2 ./
rsync -a slurm-sim-3:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_3 ./
rsync -a slurm-sim-4:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_4 ./
rsync -a slurm-sim-5:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_5 ./

[2022-01-12T03:39:07.115]
[2022-02-10T13:53:40.221]

rm -rf vc_sim_${VC_SIM_DIR}/pmlog/2022021[1-9]* vc_sim_${VC_SIM_DIR}/pmlog/2022022* vc_sim_${VC_SIM_DIR}/pmlog/202203*

sudo rm -rf ${PCP_LOG}/202201*
sudo rm -rf ${PCP_LOG}/202202*
sudo rm -rf ${PCP_LOG}/202203[012]*

du -h vc_sim_${VC_SIM_DIR}

rsync -a slurm-sim-1-2:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_6 ./
rsync -a slurm-sim-3:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_8 ./
rsync -a slurm-sim-4:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_9 ./
rsync -a slurm-sim-5:/home/centos/slurm_sim_ws/slurm_model/ubhpc/vc_sim_10 ./


7 5



```bash
# run local
start_conda
conda activate slurm_analyser
export PATH=/home/nikolays/slurm_sim_ws/slurm_sim_tools/bin:/home/nikolays/slurm_sim_ws/slurm_sim_deb/bin:/home/nikolays/slurm_sim_ws/slurm_sim_deb/sbin:$PATH
export SLURM_CONF=/home/nikolays/slurm_sim_ws/slurm_model/ubhpc/etc_sim/slurm.conf

CLUS_DIR=/home/nikolays/slurm_sim_ws/slurm_model/ubhpc

rm var/* log_loc/*; rm -rf var/spool/* var/state/*

slurmsim -v run_sim -s /home/nikolays/slurm_sim_ws/slurm_sim_deb \
    -e ${CLUS_DIR}/etc_sim \
    -a ${CLUS_DIR}/vctools/sacctmgr.script \
    -t ${CLUS_DIR}/job_traces/workload.events \
    -r ${CLUS_DIR}/results_loc -d -v \
    -octld ${CLUS_DIR}/results_loc/dtstart_${dtstart}_${replica}_ctld.out \
    -odbd ${CLUS_DIR}/results_loc/dtstart_${dtstart}_${replica}_dbd.out \
    -dtstart 10 --no-slurmd --no-slurmctld
squeue -o "%.18i %.9P %.18j %.8u %.2t %.10M %.6D %R"


slurmsim -v run_sim -s /home/nikolays/slurm_sim_ws/slurm_sim_deb \
    -e ${CLUS_DIR}/etc_sim \
    -a ${CLUS_DIR}/vctools/sacctmgr.script \
    -t ${CLUS_DIR}/job_traces/jobs500_shrinked.events \
    -r ${CLUS_DIR}/results_loc -d -v \
    -octld ${CLUS_DIR}/results_loc/dtstart_${dtstart}_${replica}_ctld.out \
    -odbd ${CLUS_DIR}/results_loc/dtstart_${dtstart}_${replica}_dbd.out \
    -dtstart 58 --no-slurmd --no-slurmctld

sacct --allclusters --allusers \
    --parsable2 --allocations \
    --format jobid,jobidraw,cluster,partition,account,group,gid,\
user,uid,submit,eligible,start,end,elapsed,exitcode,state,nnodes,\
ncpus,reqcpus,reqmem,reqtres,timelimit,qos,nodelist,jobname,NTasks \
    --state CANCELLED,COMPLETED,FAILED,NODE_FAIL,PREEMPTED,TIMEOUT \
    --starttime 2021-01-01 --endtime 2023-01-01
```


```bash

for i in {1..10}
do
    case $i in
        1)
            dtstart=55
            ;;
        2)
            dtstart=137
            ;;
        3)
            dtstart=37
            ;;
        4)
            dtstart=232
            ;;
        5)
            dtstart=234
            ;;
        6)
            dtstart=49
            ;;
        7)
            dtstart=79
            ;;
        8)
            dtstart=241
            ;;
        9)
            dtstart=71
            ;;
        10)
            dtstart=261
            ;;
      *)
        dtstart=10
        ;;
   esac
   
   echo mv vc_sim_$i dtstart_${dtstart}_1
done

dtstarts="37 49 55 71 137 232 241 261"
for dtstart in $dtstarts
do
    echo dtstart_${dtstart}_1
    zstdcat dtstart_${dtstart}_1/slurm_acct.out.zst | wc -l 
done
```

