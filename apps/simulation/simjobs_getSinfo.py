#!usr/bin/env/python3
import os
import datetime
from subprocess import PIPE,run

if __name__ == '__main__':
    curTime = datetime.datetime.now()
    print(curTime,end=' ')
    output = run(['sinfo','-sh'], stdout=PIPE, stderr=PIPE).stdout
    output = output.decode('ascii')
    output.replace('\n',"")
    print(output,end='')