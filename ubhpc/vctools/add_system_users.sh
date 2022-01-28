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
useradd ${USERADD_FLAG} -u 10000 -s /bin/bash user000 && echo 'user000:user' |chpasswd
useradd ${USERADD_FLAG} -u 10001 -s /bin/bash user001 && echo 'user001:user' |chpasswd
useradd ${USERADD_FLAG} -u 10002 -s /bin/bash user002 && echo 'user002:user' |chpasswd
useradd ${USERADD_FLAG} -u 10003 -s /bin/bash user003 && echo 'user003:user' |chpasswd
useradd ${USERADD_FLAG} -u 10004 -s /bin/bash user004 && echo 'user004:user' |chpasswd
useradd ${USERADD_FLAG} -u 10005 -s /bin/bash user005 && echo 'user005:user' |chpasswd
useradd ${USERADD_FLAG} -u 10006 -s /bin/bash user006 && echo 'user006:user' |chpasswd
useradd ${USERADD_FLAG} -u 10007 -s /bin/bash user007 && echo 'user007:user' |chpasswd
useradd ${USERADD_FLAG} -u 10008 -s /bin/bash user008 && echo 'user008:user' |chpasswd
useradd ${USERADD_FLAG} -u 10009 -s /bin/bash user009 && echo 'user009:user' |chpasswd
useradd ${USERADD_FLAG} -u 10010 -s /bin/bash user010 && echo 'user010:user' |chpasswd
useradd ${USERADD_FLAG} -u 10011 -s /bin/bash user011 && echo 'user011:user' |chpasswd
useradd ${USERADD_FLAG} -u 10012 -s /bin/bash user012 && echo 'user012:user' |chpasswd
useradd ${USERADD_FLAG} -u 10013 -s /bin/bash user013 && echo 'user013:user' |chpasswd
useradd ${USERADD_FLAG} -u 10014 -s /bin/bash user014 && echo 'user014:user' |chpasswd
useradd ${USERADD_FLAG} -u 10015 -s /bin/bash user015 && echo 'user015:user' |chpasswd
useradd ${USERADD_FLAG} -u 10016 -s /bin/bash user016 && echo 'user016:user' |chpasswd
useradd ${USERADD_FLAG} -u 10017 -s /bin/bash user017 && echo 'user017:user' |chpasswd
useradd ${USERADD_FLAG} -u 10018 -s /bin/bash user018 && echo 'user018:user' |chpasswd
useradd ${USERADD_FLAG} -u 10019 -s /bin/bash user019 && echo 'user019:user' |chpasswd
useradd ${USERADD_FLAG} -u 10020 -s /bin/bash user020 && echo 'user020:user' |chpasswd
useradd ${USERADD_FLAG} -u 10021 -s /bin/bash user021 && echo 'user021:user' |chpasswd
useradd ${USERADD_FLAG} -u 10022 -s /bin/bash user022 && echo 'user022:user' |chpasswd
useradd ${USERADD_FLAG} -u 10023 -s /bin/bash user023 && echo 'user023:user' |chpasswd
useradd ${USERADD_FLAG} -u 10024 -s /bin/bash user024 && echo 'user024:user' |chpasswd
useradd ${USERADD_FLAG} -u 10025 -s /bin/bash user025 && echo 'user025:user' |chpasswd
useradd ${USERADD_FLAG} -u 10026 -s /bin/bash user026 && echo 'user026:user' |chpasswd
useradd ${USERADD_FLAG} -u 10027 -s /bin/bash user027 && echo 'user027:user' |chpasswd
useradd ${USERADD_FLAG} -u 10028 -s /bin/bash user028 && echo 'user028:user' |chpasswd
useradd ${USERADD_FLAG} -u 10029 -s /bin/bash user029 && echo 'user029:user' |chpasswd
useradd ${USERADD_FLAG} -u 10030 -s /bin/bash user030 && echo 'user030:user' |chpasswd
useradd ${USERADD_FLAG} -u 10031 -s /bin/bash user031 && echo 'user031:user' |chpasswd
useradd ${USERADD_FLAG} -u 10032 -s /bin/bash user032 && echo 'user032:user' |chpasswd
useradd ${USERADD_FLAG} -u 10033 -s /bin/bash user033 && echo 'user033:user' |chpasswd
useradd ${USERADD_FLAG} -u 10034 -s /bin/bash user034 && echo 'user034:user' |chpasswd
useradd ${USERADD_FLAG} -u 10035 -s /bin/bash user035 && echo 'user035:user' |chpasswd
useradd ${USERADD_FLAG} -u 10036 -s /bin/bash user036 && echo 'user036:user' |chpasswd
useradd ${USERADD_FLAG} -u 10037 -s /bin/bash user037 && echo 'user037:user' |chpasswd
useradd ${USERADD_FLAG} -u 10038 -s /bin/bash user038 && echo 'user038:user' |chpasswd
useradd ${USERADD_FLAG} -u 10039 -s /bin/bash user039 && echo 'user039:user' |chpasswd
useradd ${USERADD_FLAG} -u 10040 -s /bin/bash user040 && echo 'user040:user' |chpasswd
useradd ${USERADD_FLAG} -u 10041 -s /bin/bash user041 && echo 'user041:user' |chpasswd
useradd ${USERADD_FLAG} -u 10042 -s /bin/bash user042 && echo 'user042:user' |chpasswd
useradd ${USERADD_FLAG} -u 10043 -s /bin/bash user043 && echo 'user043:user' |chpasswd
useradd ${USERADD_FLAG} -u 10044 -s /bin/bash user044 && echo 'user044:user' |chpasswd
useradd ${USERADD_FLAG} -u 10045 -s /bin/bash user045 && echo 'user045:user' |chpasswd
useradd ${USERADD_FLAG} -u 10046 -s /bin/bash user046 && echo 'user046:user' |chpasswd
useradd ${USERADD_FLAG} -u 10047 -s /bin/bash user047 && echo 'user047:user' |chpasswd
useradd ${USERADD_FLAG} -u 10048 -s /bin/bash user048 && echo 'user048:user' |chpasswd
useradd ${USERADD_FLAG} -u 10049 -s /bin/bash user049 && echo 'user049:user' |chpasswd
useradd ${USERADD_FLAG} -u 10050 -s /bin/bash user050 && echo 'user050:user' |chpasswd
useradd ${USERADD_FLAG} -u 10051 -s /bin/bash user051 && echo 'user051:user' |chpasswd
useradd ${USERADD_FLAG} -u 10052 -s /bin/bash user052 && echo 'user052:user' |chpasswd
useradd ${USERADD_FLAG} -u 10053 -s /bin/bash user053 && echo 'user053:user' |chpasswd
useradd ${USERADD_FLAG} -u 10054 -s /bin/bash user054 && echo 'user054:user' |chpasswd
useradd ${USERADD_FLAG} -u 10055 -s /bin/bash user055 && echo 'user055:user' |chpasswd
useradd ${USERADD_FLAG} -u 10056 -s /bin/bash user056 && echo 'user056:user' |chpasswd
useradd ${USERADD_FLAG} -u 10057 -s /bin/bash user057 && echo 'user057:user' |chpasswd
useradd ${USERADD_FLAG} -u 10058 -s /bin/bash user058 && echo 'user058:user' |chpasswd
useradd ${USERADD_FLAG} -u 10059 -s /bin/bash user059 && echo 'user059:user' |chpasswd
useradd ${USERADD_FLAG} -u 10060 -s /bin/bash user060 && echo 'user060:user' |chpasswd
useradd ${USERADD_FLAG} -u 10061 -s /bin/bash user061 && echo 'user061:user' |chpasswd
useradd ${USERADD_FLAG} -u 10062 -s /bin/bash user062 && echo 'user062:user' |chpasswd
useradd ${USERADD_FLAG} -u 10063 -s /bin/bash user063 && echo 'user063:user' |chpasswd
useradd ${USERADD_FLAG} -u 10064 -s /bin/bash user064 && echo 'user064:user' |chpasswd
useradd ${USERADD_FLAG} -u 10065 -s /bin/bash user065 && echo 'user065:user' |chpasswd
useradd ${USERADD_FLAG} -u 10066 -s /bin/bash user066 && echo 'user066:user' |chpasswd
useradd ${USERADD_FLAG} -u 10067 -s /bin/bash user067 && echo 'user067:user' |chpasswd
useradd ${USERADD_FLAG} -u 10068 -s /bin/bash user068 && echo 'user068:user' |chpasswd
useradd ${USERADD_FLAG} -u 10069 -s /bin/bash user069 && echo 'user069:user' |chpasswd
useradd ${USERADD_FLAG} -u 10070 -s /bin/bash user070 && echo 'user070:user' |chpasswd
useradd ${USERADD_FLAG} -u 10071 -s /bin/bash user071 && echo 'user071:user' |chpasswd
useradd ${USERADD_FLAG} -u 10072 -s /bin/bash user072 && echo 'user072:user' |chpasswd
useradd ${USERADD_FLAG} -u 10073 -s /bin/bash user073 && echo 'user073:user' |chpasswd
useradd ${USERADD_FLAG} -u 10074 -s /bin/bash user074 && echo 'user074:user' |chpasswd
useradd ${USERADD_FLAG} -u 10075 -s /bin/bash user075 && echo 'user075:user' |chpasswd
useradd ${USERADD_FLAG} -u 10076 -s /bin/bash user076 && echo 'user076:user' |chpasswd
useradd ${USERADD_FLAG} -u 10077 -s /bin/bash user077 && echo 'user077:user' |chpasswd
useradd ${USERADD_FLAG} -u 10078 -s /bin/bash user078 && echo 'user078:user' |chpasswd
useradd ${USERADD_FLAG} -u 10079 -s /bin/bash user079 && echo 'user079:user' |chpasswd
useradd ${USERADD_FLAG} -u 10080 -s /bin/bash user080 && echo 'user080:user' |chpasswd
useradd ${USERADD_FLAG} -u 10081 -s /bin/bash user081 && echo 'user081:user' |chpasswd
useradd ${USERADD_FLAG} -u 10082 -s /bin/bash user082 && echo 'user082:user' |chpasswd
useradd ${USERADD_FLAG} -u 10083 -s /bin/bash user083 && echo 'user083:user' |chpasswd
useradd ${USERADD_FLAG} -u 10084 -s /bin/bash user084 && echo 'user084:user' |chpasswd
useradd ${USERADD_FLAG} -u 10085 -s /bin/bash user085 && echo 'user085:user' |chpasswd
useradd ${USERADD_FLAG} -u 10086 -s /bin/bash user086 && echo 'user086:user' |chpasswd
useradd ${USERADD_FLAG} -u 10087 -s /bin/bash user087 && echo 'user087:user' |chpasswd
useradd ${USERADD_FLAG} -u 10088 -s /bin/bash user088 && echo 'user088:user' |chpasswd
useradd ${USERADD_FLAG} -u 10089 -s /bin/bash user089 && echo 'user089:user' |chpasswd
useradd ${USERADD_FLAG} -u 10090 -s /bin/bash user090 && echo 'user090:user' |chpasswd
useradd ${USERADD_FLAG} -u 10091 -s /bin/bash user091 && echo 'user091:user' |chpasswd
useradd ${USERADD_FLAG} -u 10092 -s /bin/bash user092 && echo 'user092:user' |chpasswd
useradd ${USERADD_FLAG} -u 10093 -s /bin/bash user093 && echo 'user093:user' |chpasswd
useradd ${USERADD_FLAG} -u 10094 -s /bin/bash user094 && echo 'user094:user' |chpasswd
useradd ${USERADD_FLAG} -u 10095 -s /bin/bash user095 && echo 'user095:user' |chpasswd
useradd ${USERADD_FLAG} -u 10096 -s /bin/bash user096 && echo 'user096:user' |chpasswd
useradd ${USERADD_FLAG} -u 10097 -s /bin/bash user097 && echo 'user097:user' |chpasswd
useradd ${USERADD_FLAG} -u 10098 -s /bin/bash user098 && echo 'user098:user' |chpasswd
useradd ${USERADD_FLAG} -u 10099 -s /bin/bash user099 && echo 'user099:user' |chpasswd