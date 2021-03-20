#!/usr/bin/env python3
import sys
import os.path

if __name__ == "__main__": 
    if len(sys.argv) != 2:
        print("usage: {} names.txt".format((sys.argv[0])))
        sys.exit(0)

    if not os.path.exists(sys.argv[1]): 
        print("{} not found".format(sys.argv[1]))
        sys.exit(0)

    for line in open(sys.argv[1]):
        name = ''.join([c for c in line if  c == " " or  c.isalpha()])

        tokens = name.lower().split()

        # skip empty lines
        if len(tokens) < 1: 
            continue

        fname = tokens[0]
        lname = tokens[-1]

        print(fname + lname)           # johndoe
        print(lname + fname)           # doejohn
        print(fname + "." + lname)     # john.doe
        print(lname + "." + fname)     # doe.john
        print(lname + fname[0])        # doej
        print(fname[0] + lname)        # jdoe
        print(lname[0] + fname)        # djoe
        print(fname[0] + "." + lname)  # j.doe
        print(lname[0] + "." + fname)  # d.john
        print(fname)                   # john
        print(lname)                   # joe
