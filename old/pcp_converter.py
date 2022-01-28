#!/usr/bin/env python3
import sys


class Convert:
    def __init__(self, filename: str):
        self.filename = filename

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
        print(str_list[0] + ",{},{},{},{},{},{}".format(first_col, second_col, third_col, fourth_col, fifth_col,
                                                        sixth_col))

    def read_file(self):
        rowCount = 0
        with open(self.filename, newline='')as inputfile:
            for row in inputfile:
                if rowCount <= 15:
                    print(row.rstrip('\n'))
                    rowCount += 1
                    continue
                row_list = row.split(",")
                self.parse_row(row_list)
        print("Read finished")

    def run(self):
        self.read_file()


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Please provide jobs file to run")
        exit(-1)

    convert = Convert(sys.argv[1])
    convert.run()
