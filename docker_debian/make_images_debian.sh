#!/bin/bash
#Build all images

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &&pwd )"
SLURM_MODEL_DIR="$( dirname "${CUR_DIR}" )"

#exit on any error

cd "${SLURM_MODEL_DIR}"

#MAKING SLURM DEBs
# Making a directory for DEB Storage
[[ ! -d "./docker_debian/DEB" ]] && mkdir -p docker_debian/DEB
rm -rf "./docker_debian/DEB/*"

#Build Docker Image for making Slurm
docker build -t pseudo/slurm_deb_maker:latest -f ./docker_debian/MakeSlurmDEB.Dockerfile .

#Run the Docker Image to make Slurm binaries
docker run --name slurm_deb_maker -h slurm_deb_maker \
           -v `pwd`/docker_debian/DEB:/root/debuild \
           --rm \
           -it pseudo/slurm_deb_maker:latest make_slurm_deb

#Make Common Image for the cluster nodes
docker build -f docker_debian/Common.Dockerfile -t pseudo/slurm_common:latest .

#Make HeadNode Image
docker build -f docker_debian/HeadNode.Dockerfile -t pseudo/slurm_head_node:latest .

#Make ComputeNode Image
docker build -f docker_debian/ComputeNode.Dockerfile -t pseudo/slurm_compute_node:latest .
