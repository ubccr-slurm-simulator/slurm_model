configs and job traces for micro1 test cluster

This uses containers created in [../docker/](../docker/README.MD).

To start cluster in interactive mode:

```bash
# create network
docker network create -d bridge virtual-cluster

# launch head-node in separate terminal
docker run -it --rm -h head-node -p 222:22 --name head-node \
    --network virtual-cluster \
    -v `pwd`:/slurm_model -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
    pseudo/slurm_head_node:latest

# launch compute-nodes in separate terminal
node_name=compute000
docker run -it --rm -h ${node_name} --name ${node_name}   \
   --network virtual-cluster \
   -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
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
    pseudo/slurm_head_node:latest

# launch compute-nodes
for i in {0..1}
do
   node_name=$(printf "%03d" $i)
   docker run -d --rm -h ${node_name} --name ${node_name}   \
       --network virtual-cluster \
       -v `pwd`/micro1/etc:/etc/slurm -v /tmp:/scratch \
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
