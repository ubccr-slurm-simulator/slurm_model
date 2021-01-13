# Slurm
Slurm is an workload manager for super computers. Is a free and open source job scheduler for Linux and Unix liked kernels 
- [Reference can be found](https://slurm.schedmd.com/overview.html)

# Slurm Testbed
Slurm testbed is based on docker, which provides a environment for testing different configuration of Slurm as well as model system performance based on historical workload. In addition, it's also a platform for the future development of slurm simulator

## How to use:
### Install docker:
```
https://docs.docker.com/
```
## Make slurm images:
```
sudo ./slurm_model/docker/make_images
```
### Start docker containers:
```
sudo ./micro1_vc_start
```
---
## In docker containers
#### Begin jobs distribution
```python
python3 -u simjobs.py -t <reduce_ratio> -rt <run time> <simulation souce file> > <output file>
``` 
