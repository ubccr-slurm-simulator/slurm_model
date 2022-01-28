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

# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


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
docker compose up -d
sleep 10
workload=small
dtstart=10
replica=1
docker exec micro3-headnode-1 /opt/cluster/slurm_sim_tools/src/slurmsimtools/run_slurm.py \
            -s /usr -e /etc/slurm             \
            -a /opt/cluster/vctools/sacctmgr.script \
            -t /opt/cluster/job_traces/${workload}.events \
            -r /root/results/test/${workload}_dtstart_${dtstart}_${replica} -d -v -dtstart $dtstart --no-slurmd >& ${workload}_dtstart_${dtstart}_${replica}.out
docker compose stop
docker compose rm -f -s -v

# to get on head node for debug
docker exec -it micro3-headnode-1 bash
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
 

```bash
./start_sim -w small.events -n small_simbase_ref
./start_sim -w jobs500_shrinked.events -n jobs500_shrinked_simbase__ref

```
