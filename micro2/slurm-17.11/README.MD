# Building Docker Container

```bash
# Working in root of repo
# Using Slurm simulator repository:
docker build -f ./micro2/SlurmVC_SimRepo.Dockerfile -t nsimakov/slurm_vc:slurm-17.11-sim .
```

# Running Virtual Cluster

```bash
./run_vc.sh -jb job500org -s v1 -normal
```
