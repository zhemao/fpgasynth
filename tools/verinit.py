#!/usr/bin/env python
# Reads values line by line on standard input and generates
# A verilog initialization on standard output

import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        varname = 'data'
    else:
        varname = sys.argv[1]

    for i, line in enumerate(sys.stdin):
        code = "\t%s[%d] = %s;" % (varname, i, line.strip())
        print(code)
