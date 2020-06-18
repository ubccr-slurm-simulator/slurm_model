import sys
import os


def sleep(intervel):
    print("sleep app")
    os.system('cd ../Sleep/ && make run time=' + str(intervel))


def memoryGrow(size):
    print("MemoryGrow")
    os.system('cd ../MemoryGrow/ && make run size='+str(size))


def matrixMultiplication(size, calctime, sleeptime):
    print("MatrixMultiplication")
    os.system('cd ../MatrixMultiplication/ && make run size=' + str(size)+' calcSeconds=' + str(calctime)
              + ' sleepSeconds=' + str(sleeptime))


def controller():
    program = sys.argv[1]
    if program == "Sleep":
        if len(sys.argv) - 1 < 2:
            print("Not enough argument for sleep, require <time>")
            sys.exit()
        else:
            sleep(int(sys.argv[2]))

    elif program == "MemoryGrow":
        memoryGrow(sys.argv[2])

    elif program == "MatrixMultiplication":
        if len(sys.argv) - 1 < 4:
            print("Not enough argument for sleep, require <time>")
            sys.exit()
        else:
            matrixMultiplication(sys.argv[2], sys.argv[3], sys.argv[4])


    else:
        print("Invalid input")

def main():
    controller()


if __name__ == '__main__':
    main()
