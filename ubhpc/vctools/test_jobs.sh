#!/usr/bin/env bash
cd
sbatch -J reg1core -q general-compute -N 1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 1 -n 40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J bigmem -q general-compute -N 1 -n 40 -t 15:00 --mem=512G /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 --gres=gpu:1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu2 -q general-compute -N 1 -n 2 --gres=gpu:2 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J gpu1 -q general-compute -N 1 -n 1 --gres=gpu:1 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg8cores -q general-compute -N 1 -n 8 -t 15:00 /usr/local/microapps/sleep.job 300

for i in {1..10}
do
sbatch -J reg1core -q general-compute -N 1 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 4 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 8 --ntasks-per-node=40 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1core -q general-compute -N 1 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 2 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 4 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
sbatch -J reg1node -q general-compute -N 8 --ntasks-per-node=32 -t 15:00 /usr/local/microapps/sleep.job 300
done

