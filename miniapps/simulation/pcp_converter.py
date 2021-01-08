#!/usr/bin/env python3
import inspect
import os
import sys

cur_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
write_dir = cur_dir + "/doc"


class Convert:
    def __init__(self, filename: str = None, sinfofile: str = None):
        self.filename = filename
        self.sinfofile = sinfofile
        self.findDistPeak = 0  # a helper variable to find peak

    def convert_unit(self, s: str) -> float:
        K: int = 1024
        M: int = 1024 * 1024
        G: int = 1024 * 1024 * 1024
        s = s.rstrip('\n')

        if s[-1].isalpha():
            temp = float(s[0:len(s) - 1])
            if s[-1] == "K":
                temp *= K
            elif s[-1] == "M":
                temp *= M
            elif s[-1] == "G":
                temp *= G
        else:
            temp = float(s)
        return temp

    def parse_row(self, str_list: list):
        first_col = self.convert_unit(str_list[1])
        second_col = self.convert_unit(str_list[2])
        third_col = self.convert_unit(str_list[3])
        fourth_col = self.convert_unit(str_list[4])
        fifth_col = self.convert_unit(str_list[5])
        sixth_col = self.convert_unit(str_list[6])
        out_peak: int = 0
        if second_col == 0:
            self.findDistPeak += 1
        elif second_col != 0:
            if self.findDistPeak == 0:
                out_peak = 1
            else:
                out_peak = self.findDistPeak+1
            self.findDistPeak = 0

        print(str_list[0] + ",{:0>2f},{:0>2f},{:0>2f},{},{},{},{}".format(first_col, second_col, third_col, fourth_col,
                                                                          fifth_col,
                                                                          sixth_col, out_peak))
        out_peak = 0

    def read_file(self):
        pcp_data = []
        sinfo_data = []
        with open(self.filename, newline='')as inputfile:
            for row in inputfile:
                pcp_data.append(row)
        inputfile.close()
        if self.sinfofile:
            with open(self.sinfofile, newline='')as infoinput:
                for row in infoinput:
                    sinfo_data.append(row)
            infoinput.close()
        return pcp_data, sinfo_data if sinfo_data != [] else None

    def process_intput(self, pcp_data: list = None, sinfo_data: list = None):
        rowCount = 0
        for row in pcp_data:
            if rowCount <= 15:
                print(row.rstrip('\n'))
                rowCount += 1
                continue
            row_list = row.split(",")
            self.parse_row(row_list)

        if sinfo_data:
            res = []
            for row in sinfo_data:
                try:
                    row_list = row.split()
                    temp = row_list[1].split(".", 1)
                    time: str = row_list[0] + " " + temp[0]
                    nodes = row_list[5].split("/", 4)
                    res.append(time + "," + nodes[0]+","+nodes[2])
                except:
                    res.append("error")
            with open(write_dir + '/' + "sinfo_converted.txt", 'w')as filewriter:
                for row in res:
                    filewriter.write(row)
                    filewriter.write("\n")

    def run(self):
        pcp_data, sinfo_data = self.read_file()
        self.process_intput(pcp_data, sinfo_data)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Please provide jobs file to run")
        exit(-1)
    if len(sys.argv) > 2:
        convert = Convert(sys.argv[1], sys.argv[2])
    else:
        convert = Convert(sys.argv[1])
    convert.run()
