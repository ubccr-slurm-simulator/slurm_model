#!/bin/bash
echo "Adding users to the system..."
if [[ "`hostname`" == "headnode" ]]; then
    echo "headnode."
    USERADD_FLAG="-m"
else
    echo "computenode."
    USERADD_FLAG="-M"
fi
USERADD_FLAG="${USERADD_FLAG} -N -g users"

# for i in range(100):
#     print(f"useradd ${{USERADD_FLAG}} -u {10000+i:d} -s /bin/bash user{i:03d} && echo 'user{i:03d}:user' |chpasswd")
useradd ${USERADD_FLAG} -u 10001 -s /bin/bash user1 && echo 'user1:user' |chpasswd
useradd ${USERADD_FLAG} -u 10002 -s /bin/bash user2 && echo 'user2:user' |chpasswd
useradd ${USERADD_FLAG} -u 10003 -s /bin/bash user3 && echo 'user3:user' |chpasswd
useradd ${USERADD_FLAG} -u 10004 -s /bin/bash user4 && echo 'user4:user' |chpasswd
useradd ${USERADD_FLAG} -u 10005 -s /bin/bash user5 && echo 'user5:user' |chpasswd

