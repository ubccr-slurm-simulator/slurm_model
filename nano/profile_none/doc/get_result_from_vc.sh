#!/usr/bin/env bash
set -e
app="mulmat"
cores1="single_core/${app}"
cores4="four_cores/${app}"
cores8="eight_cores/${app}"
cores88="eight_eight_cores/${app}"
cores48="four_eight_cores/${app}"
#scp vc:/home/centos/slurm_model/nano/profile_10s/"${cores}"/profile_io.out ../res/"${cores}"/profile_io.out
python3 pcp_converter.py ../res/"${cores1}"/profile_io.out > ../res/"${cores1}"/profile_io_converted.txt
python3 pcp_converter.py ../res/"${cores4}"/profile_io.out > ../res/"${cores4}"/profile_io_converted.txt
python3 pcp_converter.py ../res/"${cores8}"/profile_io.out > ../res/"${cores8}"/profile_io_converted.txt
python3 pcp_converter.py ../res/"${cores48}"/profile_io.out > ../res/"${cores48}"/profile_io_converted.txt
python3 pcp_converter.py ../res/"${cores88}"/profile_io.out > ../res/"${cores88}"/profile_io_converted.txt
