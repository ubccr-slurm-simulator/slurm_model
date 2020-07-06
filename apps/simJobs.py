#!/usr/bin/env python3
import inspect
import sys
import os
import csv
import time


cur_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

class SimJobs:
    def __init__(self,filename):
        self.filename = filename

    def sendToBatch(self, elapsedTime, nnode, ncpus):
        time.sleep(10)
        cmd = 'sudo su - user1 -c "sbatch -p normal -q normal -A account1 -N {} -t {} /usr/local/apps/sleep.job 60 0'.format(nnode,elapsedTime)
        os.system(cmd)


    def readFile(self):
        with open(self.filename, newline='')as inputfile:
            fileReader = csv.reader(inputfile, delimiter = ',')
            for row in fileReader:
                elapsedTime = row[14]
                nnodes = row[17]
                ncpus = row[18]
                print("Elapsed time = "+row[14]+" number of nodes = "+row[17] + " number of cpus per nodes: "+row[18])
                self.sendToBatch(elapsedTime, nnodes, ncpus)



    def run(self):
        self.readFile()


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Please provide jobs file to run")
        exit(-1)

    simJobs = SimJobs(sys.argv[1])
    simJobs.run()
    print("All simulation process completed")
