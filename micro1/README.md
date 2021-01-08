configs and job traces for micro1 test cluster

This uses containers created in [../docker/](../docker/README.MD).

The Slurm config directory is mounted as volume from  micro1/etc.

Scratch directory is mounted as volume from  /tmp and served as a shared file-system.

# Starting/Stopping Virtual Cluster

To start cluster:
```bash
cd micro1
./vc_strart
```

To start cluster manually:

```bash
# change to micro1 directory
cd ./micro1
 
# create network
docker network create -d bridge \
    --subnet=172.31.0.0/16 \
    --ip-range=172.31.0.0/16 \
    --gateway=172.31.0.254 \
    virtual-cluster

# create volume for shared home directories
docker volume create vc-home

# volumes mounting
mount_volumes="-v `pwd`/..:/slurm_model -v `pwd`/etc:/etc/slurm -v /tmp:/scratch \
    -v vc_home:/home \
    -v `pwd`/vctools:/vctools \
    -v `pwd`/../miniapps:/usr/local/miniapps"

# launch head-node in separate terminal
docker run -it --rm -h head-node -p 222:22 --name head-node \
    --network virtual-cluster --ip=172.31.0.1 \
    ${mount_volumes} \
    pseudo/slurm_head_node:latest

# launch compute-nodes in separate terminal
node_name=compute000
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster --ip=172.31.0.100 \
   ${mount_volumes} -v /sys/fs/cgroup:/sys/fs/cgroup \
   pseudo/slurm_compute_node:latest

# launch compute-nodes in separate terminal
node_name=compute001
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster  --ip=172.31.0.101 \
   ${mount_volumes} -v /sys/fs/cgroup:/sys/fs/cgroup \
   pseudo/slurm_compute_node:latest
```

To start cluster in detached mode:

```bash
./vcstart
# access head-node
docker exec -it head-node bash
```

To delete cluster:

```bash
./vc_stop
```

# Adding accounts
Automatically from init_slurm script

# Run some tests jobs

```bash
sudo su - user1 -c "sbatch -p normal -q normal -A account1 -N 1 -t 5:00 /usr/local/miniapps/sleep_srun.job 60 0"

sbatch -p normal -q normal -A account1 -N 1 -t 5:00 /usr/local/miniapps/sleep_srun.job 60 0

salloc -p normal -q normal -A account1 -N 1 -t 5:00
```


```bash
cd /home
for u in admin  slurm  user1  user2  user3  user4  user5
do
    chown -R $u:$u $u
done

```

# Monitoring IO for Profiler

```bash
# Monitor

# monitor with PCP
sudo apt install pcp pcp-gui

# Stop
```


