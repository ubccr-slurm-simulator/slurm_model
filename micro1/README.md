configs and job traces for micro1 test cluster

This uses containers created in [../docker/](../docker/README.MD).

The Slurm config directory is mounted as volume from  micro1/etc.

Scratch directory is mounted as volume from  /tmp and served as a shared file-system.

# Starting/Stopping Virtual Cluster

To start cluster in interactive mode:

```bash
# create network
docker network create -d bridge virtual-cluster

# launch head-node in separate terminal
docker run -it --rm -h head-node -p 222:22 --name head-node \
    --network virtual-cluster \
    -v `pwd`:/slurm_model -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
    -v `pwd`/apps:/usr/local/apps \
    pseudo/slurm_head_node:latest

# launch compute-nodes in separate terminal
node_name=compute000
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster \
   -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
   -v `pwd`/apps:/usr/local/apps \
   pseudo/slurm_compute_node:latest

# launch compute-nodes in separate terminal
node_name=compute001
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster \
   -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
   pseudo/slurm_compute_node:latest
```

To start cluster in detached mode:

```bash
# create network
docker network create -d bridge virtual-cluster

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
```

# Adding accounts

```bash
# as a root or slurm user
# add/modify QOS
sacctmgr  -i modify QOS set normal Priority=0
sacctmgr  -i add QOS Name=supporters Priority=100
# add cluster
sacctmgr -i add cluster Name=micro Fairshare=1 QOS=normal,supporters
# add accounts
sacctmgr -i add account name=account0 Fairshare=100
sacctmgr -i add account name=account1 Fairshare=100
sacctmgr -i add account name=account2 Fairshare=100
# add admin
sacctmgr -i add user name=admin DefaultAccount=account0 MaxSubmitJobs=1000 AdminLevel=Administrator
# add users
sacctmgr -i add user name=user1 DefaultAccount=account1 MaxSubmitJobs=1000
sacctmgr -i add user name=user2 DefaultAccount=account1 MaxSubmitJobs=1000
sacctmgr -i add user name=user3 DefaultAccount=account1 MaxSubmitJobs=1000
sacctmgr -i add user name=user4 DefaultAccount=account2 MaxSubmitJobs=1000
sacctmgr -i add user name=user5 DefaultAccount=account2 MaxSubmitJobs=1000 
# add users to qos level
sacctmgr -i modify user set qoslevel="normal,supporters"

# check results
sacctmgr list associations format=Account,Cluster,User,Fairshare tree withd

```

# Run some tests jobs

```bash
sudo su - user1 -c "sbatch -p normal -q normal -A account1 -N 1 -t 5:00 /usr/local/apps/sleep.job 60 0"
```

