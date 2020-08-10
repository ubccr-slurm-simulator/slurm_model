#!/usr/bin/env bash
set -e
app="sleep"
node1="single_node/${app}"
node2="two_nodes/${app}"
node4="four_nodes/${app}"
node42="four_two_nodes/${app}"

#scp vc:/home/centos/slurm_model/nano/profile_10s/"${cores}"/profile_io.out ../res/"${cores}"/profile_io.out
python3 pcp_converter.py ../"${node1}"/profile_io.out > ../"${node1}"/profile_io_converted.txt
python3 pcp_converter.py ../"${node2}"/profile_io.out > ../"${node2}"/profile_io_converted.txt
python3 pcp_converter.py ../"${node4}"/profile_io.out > ../"${node4}"/profile_io_converted.txt
python3 pcp_converter.py ../"${node42}"/profile_io.out > ../"${node42}"/profile_io_converted.txt

