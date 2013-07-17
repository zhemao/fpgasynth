import sys
import struct

def conv_binary(binstr):
    if len(binstr) == 32:
        data = struct.pack('<I', int(binstr, 2))
        return struct.unpack('<f', data)[0]
    else:
        data = struct.pack('<H', int(binstr, 2))
        return struct.unpack('<h', data)[0]

TO_SKIP = 3

if __name__ == '__main__':
    if len(sys.argv) < 2:
        f = sys.stdin
    else:
        f = open(sys.argv[1])

    for i in range(TO_SKIP):
        f.readline()

    for line in f:
        binstr = line.rstrip().split()[2]
        print(conv_binary(binstr))
