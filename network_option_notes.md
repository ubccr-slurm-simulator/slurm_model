# Network driver summary
  - User-defined bridge networks are best when you need multiple containers to communicate on the same Docker host.
  - Overlay networks are best when you need containers running on different Docker hosts to communicate, or when multiple applications work together using swarm services.
  - Macvlan networks are best when you are migrating from a VM setup or need your containers to look like physical hosts on your network, each with a unique MAC address.

## Default 
-   By default docker create a bridge network call docker0. Each new Docker container is automatically attached to this network.

## details 
- overlay network is for docker running on multiple host to comunicate with eachother 
  - example 2 docker host on seperate layer 2 networks connect to a layer 3 router.

## need to either initialize your Docker daemon as a swarm manager using 
    ```
    docker swarm init
    ``` 
## join it to an existing swarm using docker 
    ```
    swarm join
    ```

## create a overlay network:
    ```
    docker network create -d overlay --attachable my-overlay
    ```

## macvlan 
  - expect to be directly connected to the physical network.
  - in this case, you need to designate a physical interface on your Docker host to use for the macvlan, as well as the subnet and gateway of the macvlan. You can  even isolate your macvlan networks using different physical network interfaces.
  - 

## How to fix ip addresses on everytime docker container restart
  - Sincer docker use bridge network by default, it will change ip address everytime it start
  - fix that by giving a fix ipadress range
    ```
    docker network create --subnet=172.22.0.0/16  <name>

    ```
  - start the image   
  ```
  docker run -it --rm -h compute000 -p 222:22 --name compute000 --network <networkName> slurm_common:latest
  ```