configs and job traces for micro1 test cluster

This uses containers created in [../docker/](../docker/README.MD).

The Slurm config directory is mounted as volume from  micro1/etc.

Scratch directory is mounted as volume from  /tmp and served as a shared file-system.

# Starting/Stopping Virtual Cluster



```bash
# create network
docker network create -d bridge \
    --subnet=172.31.0.0/16 \
    --ip-range=172.31.0.0/16 \
    --gateway=172.31.0.254 \
    virtual-cluster

# create volume for shared home directories
docker volume create vc-home
```

To start cluster:

```bash
# volumes mounting
mount_volumes="-v `pwd`:/slurm_model -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
    -v vc_home:/home \
    -v `pwd`/micro1/vctools:/vctools \
    -v `pwd`/apps:/usr/local/apps"

# launch head-node in separate terminal
docker run -it --rm -h head-node -p 222:22 --name head-node \
    --network virtual-cluster --ip=172.31.0.1 \
    ${mount_volumes} \
    pseudo/slurm_head_node:latest

# launch compute-nodes in separate terminal
node_name=compute000
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster --ip=172.31.0.100 \
   ${mount_volumes} \
   pseudo/slurm_compute_node:latest

# launch compute-nodes in separate terminal
node_name=compute001
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster \
   -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
   -v `pwd`/micro1/home:/home \
   pseudo/slurm_compute_node:latest
```

To start cluster in detached mode:

```bash
# launch head-node
docker run -d --rm -h head-node -p 222:22 --name head-node \
    --network virtual-cluster \
    -v `pwd`:/slurm_model -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
    -v `pwd`/apps:/usr/local/apps \
    pseudo/slurm_head_node:latest

# launch compute-nodes
for i in {0..1}
do
   node_name=$(printf "%03d" $i)
   docker run -d --rm -h ${node_name} --name ${node_name}   \
       --network virtual-cluster \
       -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
       -v `pwd`/apps:/usr/local/apps \
       pseudo/slurm_compute_node:latest
done

# access head-node
docker exec -it head-node bash
```

To delete cluster:

```bash
# terminate and remove head-node
docker container stop head-node
docker container rm head-node
# terminate and remove compute-nodes
for i in {0..1}
do
    node_name=$(printf "%03d" $i)
    docker container stop ${node_name}
    docker container rm ${node_name}
done
# possibly delete network
docker network rm virtual-cluster
# possibly delete home directories
docker volume remove vc-home
```

# Adding accounts
Automatically from init_slurm script

# Run some tests jobs

```bash
sudo su - user1 -c "sbatch -p normal -q normal -A account1 -N 1 -t 5:00 /usr/local/apps/sleep.job 60 0"

sbatch -p normal -q normal -A account1 -N 1 -t 5:00 /usr/local/apps/sleep.job 60 0

salloc -p normal -q normal -A account1 -N 1 -t 5:00
```


```bash
cd /home
for u in admin  slurm  user1  user2  user3  user4  user5
do
    chown -R $u:$u $u
done

```
