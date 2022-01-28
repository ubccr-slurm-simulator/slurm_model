#!/usr/bin/env python3
import csv
import datetime
import inspect
import os
import sys
import time
import math

cur_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))


class SimJobs:
    def __init__(self, args):
        self.filename = args.filename[0]
        self.ratio = args.trimDownRatio
        self.runningTime = args.runTime
        self.rowCount = 0

    def sendToBatch(self, jobName, wallTime, nnode, ncpus, startTime):
        # command send to batch to execute jobs
        #-A account1 -p normal -q normal
        cmd = "sudo su - user1 -c \"sbatch " \
              "-N {} -n {} --begin={} " \
              "--mem=200M -J {} /usr/local/miniapps/mulmat.job {}\" ".format(nnode, ncpus, startTime.strftime("%Y-%m-%dT%H:%M:%S"), jobName, wallTime)
        # command send to batch to get current sinfo with time stamp
        print(cmd)
        os.system(cmd)
        getSinfo = "python3 -u /slurm_model/miniapps/simulation/simjobs_getSinfo.py >> sinfo.txt &"
        os.system(getSinfo)

    def readFile(self):
        data = []
        with open(self.filename, newline='', errors='ignore')as inputfile:
            fileReader = csv.reader(inputfile, delimiter=',')
            for row in fileReader:
                data.append(row)
        inputfile.close()
        print("Read finished")
        return data

    def processIntput(self, data: list, endTime: datetime):
        # Record to beginning time of the whole set of simulation
        # if first job, add extra one second to give enough time for slurm to process,then the whole process begin
        # add padding between each job
        #                          ->new start time is curTime + waltime + padding time

        beginTime = datetime.datetime.now()
        print("begin at :"+str(beginTime))

        for row in data:
            # skip the header
            curTime = datetime.datetime.now()
            if curTime < endTime:
                if self.rowCount == 0:
                    self.rowCount += 1
                    continue
                wallTime: str = math.floor(int(row[-3])/self.ratio)
                nnodes: int = row[17]
                ncpus: int = row[18]
                jobName: str = row[25]
                if self.rowCount == 1:
                    startTime = beginTime + datetime.timedelta(seconds=1)
                self.sendToBatch(jobName, wallTime, nnodes, ncpus, startTime)

                #add padding between each job
                #startTime = startTime + datetime.timedelta(seconds=int(row[-3])) + datetime.timedelta(seconds=int(row[-1]))

                #Production Run
                temp = math.floor(int(row[-1]) / self.ratio) if row[-1]!="NA"else 0
                print(temp)
                startTime = startTime + datetime.timedelta(seconds = temp)

                print("start at :" + str(startTime))
                self.rowCount += 1
            else:
                print("Run time is up,simulation can't finished all requested jobs")
                os.system("sudo scancel -u user1")  # cancel all jobs
                print("All jobs has been cancel")
                t = time.localtime()
                current_time = time.strftime("%Y-%m-%d %H:%M:%S", t)
                print("End at " + current_time)
                exit(1)

    def formatTime(self, seconds) -> str:
        seconds = int(seconds)
        seconds = seconds // self.ratio + 1;
        secondsToday = 60 * 60 * 24
        secondsTohour = 60 * 60
        secondsTominute = 60
        days = seconds // secondsToday
        hours = (seconds - (days * secondsToday)) // secondsTohour
        mins = (seconds - (days * secondsToday) - (hours * secondsTohour)) // secondsTominute
        seconds = seconds - (days * secondsToday) - (hours * secondsTohour) - (mins * secondsTominute)

         #prevent time set to 0-00:00:00 which cause it to run forever -> set to run at least 1 second
        if days == 0 and hours == 0 and mins == 0 and seconds == 0:
           seconds += 1

        # Round down to actual time then format to proper time
        res = "{}-{:0>2d}:{:0>2d}:{:0>2d}".format(days, hours, mins, seconds-1)
        return res

    def run(self):
        startTime = datetime.datetime.now()
        print("Start at " + str(startTime))
        if self.runningTime == 0 :
            endTime = datetime.datetime.now()+datetime.timedelta(hours=1000) # pretending running forever
        else:
            endTime = datetime.datetime.now() + datetime.timedelta(seconds=self.runningTime)
        print("end: " + str(endTime))

        data = self.readFile()
        print("Starting processing file")
        self.processIntput(data, endTime)
        print("All simulation has been submitted")

        #while datetime.datetime.now() < endTime:  # wait until running time is reached
        #    time.sleep(1)
        #print("Run time is up, canceling all jobs")
        #os.system("sudo scancel -u user1")  # cancel all jobs
        #print("All jobs has been cancel")

        t = time.localtime()
        current_time = time.strftime("%Y-%m-%d %H:%M:%S", t)
        print("End at " + current_time)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Please provide jobs file to run")
        exit(-1)

    import argparse

    parser = argparse.ArgumentParser(description='Slurm Simulator job submitter')

    parser.add_argument(dest='filename', metavar='filename', nargs='*')

    parser.add_argument("-t", "--trimDownRatio", type=int, default=1,
                        help="trim the wall time down by ratio,default = 1")

    parser.add_argument("-rt", "--runTime", type=int, default=0, help="Set time allow program to run in seconds")

    args = parser.parse_args()
    if args.trimDownRatio:
        print("trim time by " + str(args.trimDownRatio))
    print(args)
    simJobs = SimJobs(args)
    simJobs.run()
