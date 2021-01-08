Micro2 is small cluster used for validation of simulator.

This directory contains files used for generation of reference job history.

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
```

 