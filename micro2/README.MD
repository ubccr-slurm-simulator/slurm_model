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

# Running Docker Container Front End Mode

```bash
# Run shrinked jobs500
docker run --name slurm -h slurm --rm -v $(pwd)/micro2/results:/root/results \
    nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld \
    /opt/cluster/micro2/utils/run_jobs500_shrinked_frontend.sh

# Run jobs500
docker run --name slurm -h slurm --rm -v $(pwd)/micro2/results:/root/results \
    nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld \
    /opt/cluster/micro2/utils/run_jobs500_frontend.sh

# Run shrinked jobs500
nohup docker run --name slurm -h slurm --rm -v $(pwd)/micro2/results:/root/results \
    nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld \
    /opt/cluster/micro2/utils/run_jobs500_shrinked_frontend.sh &>  run_jobs500_shrinked_frontend.out &

# Run jobs500
nohup docker run --name slurm -h slurm --rm -v $(pwd)/micro2/results:/root/results \
    nsimakov/slurm_vc:slurm-20.02-sim sshd munged mysqld \
    /opt/cluster/micro2/utils/run_jobs500_frontend.sh &>  run_jobs500_frontend.out &


sed -i 's/}]/}/g' dtstart_10_3/perf_stat.log

# fixing some staff
for dtstart in 10 30 50 70 90 110
do
    for i in {1..4}
    do
        echo "Stated modelling with dtstart ${dtstart}, i ${i}"
        sed -i 's/}]/}/g' dtstart_${dtstart}_${i}/perf_stat.log
        echo "\n]" >> dtstart_10_4/perf_profile.log
    done
done

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

# on time

Tue 12 Jan 2021 09:58:59 AM EST
 