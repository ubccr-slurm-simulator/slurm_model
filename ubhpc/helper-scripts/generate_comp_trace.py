import sys
import math
import numpy
import time
import pandas as pd
import datetime as dt

filename = sys.argv[1]
outfilename = sys.argv[2]
userlog = sys.argv[3]

node_list = []
for i in range(16, 21 + 1):
    node_list.append("cpn-u22-" + str(i))
    node_list.append("cpn-u25-" + str(i))
for i in range(17, 21 + 1):
    node_list.append("cpn-u23-" + str(i))
    node_list.append("cpn-u24-" + str(i))
for i in range(23, 38 + 1):
    node_list.append("cpn-u22-" + str(i))
    node_list.append("cpn-u25-" + str(i))
    node_list.append("cpn-u23-" + str(i))
    node_list.append("cpn-u24-" + str(i))

def generate_trace(filename, outfilename, userlog):
    infile = open(filename, "r")
    BeginTime = dt.datetime(2021, 6, 1, 0, 0, 0)
    EndTime = dt.datetime(2021, 6, 8, 0, 0, 0)

    header = infile.readline()
    header = header.split("|")
    header[-1] = header[-1].strip()

    SubmitTime = []
    JobID = []
    WallTime = []
    User = []
    RequestTime = []
    NumNodes = []
    NumTasksPerNode = []
    Account = []
    Partition = []

    df = pd.DataFrame()

    lines = infile.readlines()[:-2]
    for line in lines:
        in_list = True
        line = line.split("|")

        if line[-3] == "Partition_Limit":
            continue

        if len(line[-3]) == 8:
            line[-3] = "0-" + line[-3]

        if line[11] == "Unknown" or line[12] == "Unknown" or line[9] == "Unknown" or line[-3] == "Unknown":
            continue

        line[9] = dt.datetime.strptime(line[9], "%Y-%m-%dT%H:%M:%S")
        line[11] = dt.datetime.strptime(line[11], "%Y-%m-%dT%H:%M:%S")
        line[12] = dt.datetime.strptime(line[12], "%Y-%m-%dT%H:%M:%S")
        requested = dt.datetime.strptime(line[-3], "%w-%H:%M:%S")
        requested_delta = math.ceil((requested - dt.datetime(1900, 1, 1)).total_seconds() / 1000.0)
        line[-3] = str(dt.timedelta(seconds = requested_delta))

        if ((line[9] - EndTime).total_seconds() > 0):
            continue

        line[-2] = line[-2].split(",")
        for node in line[-2]:
            if not (node in node_list):
                in_list = False
        if in_list == False:
            continue

        SubmitTime.append((line[9] - BeginTime).total_seconds() / 1000.0)
        JobID.append(line[0])
        WallTime.append((line[12] - line[11]).total_seconds() / 1000.0)
        User.append(line[7])
        RequestTime.append(line[-3])
        NumNodes.append(line[16])
        NumTasksPerNode.append(int(int(line[17]) / int(line[16])))
        Account.append(line[4])
        Partition.append(line[3])
    infile.close()

    df["SubmitTime"] = SubmitTime
    df["JobID"] = JobID
    df["WallTime"] = WallTime
    df["User"] = User
    df["RequestTime"] = RequestTime
    df["NumNodes"] = NumNodes
    df["NumTasksPerNode"] = NumTasksPerNode
    df["Account"] = Account
    df["Partition"] = Partition

    outfile = open(outfilename, "w")
    for index, row in df.iterrows():
        outfile.write("-dt " + str(row["SubmitTime"]) + " -e " + "submit_batch_job "
                        + "| " + "-jid " + str(row["JobID"]) + " -sim-walltime "
                        + str(row["WallTime"]) + " --uid=" + str(row["User"])
                        + " -t " + str(row["RequestTime"]) + " -n " + str(row["NumNodes"])
                        + " --ntasks-per-node=" + str(row["NumTasksPerNode"]) + " -A "
                        + str(row["Account"]) + " -p " + str(row["Partition"]) + " -q "
                        + str(row["Partition"]) + " pseudo.job\n")

    anon_users = []
    anon_accounts = []

    for i in range(len(df["User"])):
        if not (df["User"][i] in anon_users):
            anon_users.append(df["User"][i])
            anon_accounts.append(df["Account"][i])      

    df2 = pd.DataFrame()
    df2["Users"] = anon_users
    df2["Accounts"] = anon_accounts
    df2.to_csv(userlog)

generate_trace(filename, outfilename, userlog)