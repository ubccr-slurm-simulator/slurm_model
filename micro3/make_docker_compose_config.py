#!/usr/bin/env python3

fout = open("docker-compose.yml", "wt")
n_reg_old = 4
n_gpu_old = 0
n_reg = 4
n_mem = 1
n_gpu = 1


# n_reg_old = 8
# n_gpu_old = 2
# n_reg = 8
# n_mem = 8
# n_gpu = 8
#

fout.write("""version: "3.8"
services:
  headnode:
    image: nsimakov/slurm_head_node:3
    hostname: headnode
    shm_size: 64M
    command: ["sshd", "munged", "mysqld", "/opt/cluster/vctools/add_system_users.sh", "-loop"]
    # "/opt/cluster/vctools/start_head_node.sh" is intentionally removed here
    # run_vc.sh will start slurm services in right order and will track time
    networks:
      network1:
        ipv4_address: 172.32.0.11
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './job_traces:/opt/cluster/job_traces'
      - './log:/var/log/slurm'
      - './home:/home'
      - './../../slurm_sim_tools:/opt/cluster/slurm_sim_tools'
    cpuset: '0-3'
""")


def get_compute_node_volumes(nodename):
    return f"""volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './job_traces:/opt/cluster/job_traces'
      - './compute_nodes_log/{nodename}:/var/log/slurm'
      - './home:/home'"""\


for i in range(1,n_reg_old+1):
    hostname = f"n{i:d}"
    ip = i+100
    fout.write(f"""  {hostname}:
    image: nsimakov/slurm_compute_node:3
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.1.{ip}
    {get_compute_node_volumes(hostname)}
    cpuset: '4-7'
""")
for i in range(1, n_gpu_old + 1):
    hostname = f"gn{i:d}"
    ip = i + 200
    fout.write(f"""  {hostname}:
    image: nsimakov/slurm_compute_node:3
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.1.{ip}
    {get_compute_node_volumes(hostname)}
    cpuset: '4-7'
""")
for i in range(1,n_reg+1):
    hostname = f"  m{i:d}"
    ip = i+100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:3
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.2.{ip}
    {get_compute_node_volumes(hostname)}
    cpuset: '4-7'
""")
for i in range(1,n_mem+1):
    hostname = f"  b{i:d}"
    ip = i+100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:3
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.3.{ip}
    {get_compute_node_volumes(hostname)}
    cpuset: '4-7'
""")
for i in range(1, n_gpu+1):
    hostname = f"  g{i:d}"
    ip = i + 100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:3
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.4.{ip}
    {get_compute_node_volumes(hostname)}
    cpuset: '4-7'
""")

fout.write("""networks:
  network1:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: "172.32.0.0/21"
""")