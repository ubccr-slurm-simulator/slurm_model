#!/usr/bin/env bash
set -e

echo "single_core_3"
./nano_simulation.sh single_core_3 sleep
echo "two_cores_3"
./nano_simulation.sh two_cores_3 sleep
echo " four_cores_3"
./nano_simulation.sh four_cores_3 sleep
echo "eight_cores_3"
./nano_simulation.sh eight_cores_3 sleep
#echo "single_cores_3"
#sudo ./nano_simulation.sh single_core_3 sleep
#echo "two_cores_3"
#sudo ./nano_simulation.sh two_cores_3 sleep
#echo " four_cores_3"
#sudo ./nano_simulation.sh four_cores_3 sleep
#echo "eight_cores_3"
#sudo ./nano_simulation.sh eight_cores_3 sleep