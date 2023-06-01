# Docker Containers Development Notes


```bash
docker run --name slurm_rpm_maker -h slurm_rpm_maker \
           -v `pwd`/docker/RPMS:/RPMS \
           --rm \
           -it rockylinux:9 bash
```