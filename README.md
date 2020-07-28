# slurm_model
Slurm model is a simulator that runs across multiple docker containers on a single work station or
computer node, which allow time accelerated simulation of work load on HPC resources.
 
## How to use:
### Install docker:
```
https://docs.docker.com/
```
## Make slurm images:
```
./slurm_model/docker/make_images
```
### Start docker containers:
```
./micro1_vc_start
```
---
## In docker containers
#### Begin jobs distribution
```python
python3 -u simjobs.py -t <reduce_ratio> -rt <run time> <simulation souce file> > <output file>
``` 