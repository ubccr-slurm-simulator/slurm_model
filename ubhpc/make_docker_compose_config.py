#!/usr/bin/env python3

fout = open("docker-compose.yml", "wt")
n_reg_old = 87
n_gpu_old = 2
n_reg = 96
n_mem = 24
n_gpu = 8


# n_reg_old = 8
# n_gpu_old = 2
# n_reg = 8
# n_mem = 8
# n_gpu = 8
#

fout.write("""version: "3.8"
services:
  headnode:
    image: nsimakov/slurm_head_node:2
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
      - './log:/var/log/slurm'
      - './home:/home'
      - './../../slurm_sim_tools:/opt/cluster/slurm_sim_tools'
    cpuset: '0-3'
""")
for i in range(1,n_reg_old+1):
    hostname = f"n{i:03d}"
    ip = i+100
    fout.write(f"""  {hostname}:
    image: nsimakov/slurm_compute_node:2
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.1.{ip}
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './compute_nodes_log/n{i:03d}:/var/log/slurm'
      - './home:/home'
    cpuset: '4-7'
""")
for i in range(1, n_gpu_old + 1):
    hostname = f"gn{i:03d}"
    ip = i + 200
    fout.write(f"""  {hostname}:
    image: nsimakov/slurm_compute_node:2
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.1.{ip}
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './compute_nodes_log/n{i:03d}:/var/log/slurm'
      - './home:/home'
    cpuset: '4-7'
""")
for i in range(1,n_reg+1):
    hostname = f"  m{i:03d}"
    ip = i+100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:2
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.2.{ip}
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './compute_nodes_log/m{i:03d}:/var/log/slurm'
      - './home:/home'
    cpuset: '4-7'
""")
for i in range(1,n_mem+1):
    hostname = f"  b{i:03d}"
    ip = i+100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:2
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.3.{ip}
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './compute_nodes_log/b{i:03d}:/var/log/slurm'
      - './home:/home'
    cpuset: '4-7'
""")
for i in range(1, n_gpu+1):
    hostname = f"  g{i:03d}"
    ip = i + 100
    fout.write(f"""{hostname}:
    image: nsimakov/slurm_compute_node:2
    hostname: {hostname}
    command: ["sshd", "munged", "/opt/cluster/vctools/start_compute_node.sh", "-loop"]
    networks:
      network1:
        ipv4_address: 172.32.4.{ip}
    volumes:
      - './results:/root/results'
      - './etc:/etc/slurm'
      - './vctools:/opt/cluster/vctools'
      - './compute_nodes_log/g{i:03d}:/var/log/slurm'
      - './home:/home'
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