# Some Observed Issues

## PAM

Don't use UsePAM=1 in user.conf, Unless you know why.

## Job Stuck in CG State


In case if job stuck in CG State and slurmctld have following messages:

```
[2020-06-22T18:57:17.005] debug2: Error connecting slurm stream socket at <Wierd IP Address>:29003: Connection timed out
[2020-06-22T18:57:17.005] debug2: slurm_connect poll timeout: Connection timed out
[2020-06-22T18:57:17.005] debug2: Error connecting slurm stream socket at <Wierd IP Address>:29003: Connection timed out
[2020-06-22T18:57:17.005] debug3: problems with compute000
```

It showed up after adding shared home directory for all nodes.

Writing ips explicitly in /etc/hosts helps and so spinning of containers with --ip options resolve the problem.

Also add explicitly NodeAddr=<IP Address> in slurm.conf
