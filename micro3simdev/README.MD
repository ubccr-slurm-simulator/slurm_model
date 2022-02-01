This directory contain docker compose file for Slurm Simulator Development


```bash
docker compose up -d
docker exec -it micro3simdev-headnode-1 /bin/bash


echo "Dropping slurmdb_micro3 DB"
mysql -u root << END
drop database if exists slurmdb_micro3;
END

echo "Starting slurmdbd"
slurmdbd

sleep 10
echo "Running sacctmgr"
set +e
sacctmgr -i -p < /opt/cluster/vctools/sacctmgr.script
set -e


mkdir bld
cd ~/bld
rm -rf *
/opt/cluster/slurm_sim_tools/slurm_simulator/configure \
    --prefix=/usr  --sysconfdir=/etc/slurm --disable-x11 \
    --with-hdf5=no --enable-simulator
make -j
make -j install

slurmctld -v -e /opt/cluster/job_traces/small.events

mkdir ~/bld_deb
cd ~/bld_deb
rm -rf *
/opt/cluster/slurm_sim_tools/slurm_simulator/configure \
    --prefix=/usr  --sysconfdir=/etc/slurm --disable-x11 \
    --with-hdf5=no --enable-simulator --enable-debug --enable-front-end \
    "CFLAGS=-g -O0"
make -j
make -j install


 2204  sudo apt install libmunge-dev
 2209  sudo apt install libmysqlclient-dev


CREATE USER 'slurm'@'%' IDENTIFIED BY 'slurm';
CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'slurm';

GRANT ALL PRIVILEGES ON *.* TO 'slurm'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'slurm'@'%' WITH GRANT OPTION;

```

# run sim

```
docker run -it --rm -h headnode --name slurm_sim_head_node \
      -v `pwd`/results:/root/results \
      -v `pwd`/etc:/etc/slurm \
      -v `pwd`/../micro3/vctools:/opt/cluster/vctools \
      -v `pwd`/../micro3/job_traces:/opt/cluster/job_traces \
      -v `pwd`/log:/var/log/slurm \
      -v `pwd`/home:/home \
      -v `pwd`/../../slurm_sim_tools:/opt/cluster/slurm_sim_tools \
      -p 5000:5000 -p 2222:22 \
    nsimakov/slurm_sim_head_node:4
ssh -nNT -L 5001:localhost:5000 -p 2222 root@localhost

```

```
[root@headnode bld]# ldd /usr/sbin/slurmctld
        linux-vdso.so.1 =>  (0x00007fffd7d3c000)
        libslurmfull.so => /usr/lib/slurm/libslurmfull.so (0x00007f083d760000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f083d55c000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f083d342000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f083d13a000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f083ce38000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f083cc1c000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f083c84e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f083db39000)
[root@headnode bld]# /opt/cluster/
job_traces/      microapps/       slurm_sim_tools/ vctools/         
[root@headnode bld]# /opt/cluster/slurm_sim_tools/
bin/             developing/      docker/          .idea/           .pytest_cache/   slurm_simulator/ tests/           tmp/             ubccr/
build/           doc/             .git/            miniapps/        reg_testing/     src/             tmo/             tutorials/       
[root@headnode bld]# md5sum /usr/sbin/slurmctld
5781c0afdcc2df6cdbb216e261210f81  /usr/sbin/slurmctld
[root@headnode bld]# md5sum /usr/lib/slurm/libslurmfull.so
0f5145fe400c7591846f256b0c86c5e0  /usr/lib/slurm/libslurmfull.so
[root@headnode bld]# 
```