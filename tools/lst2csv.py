import sys
import struct

def conv_binary(binstr):
    if len(binstr) == 32:
        data = struct.pack('<I', int(binstr, 2))
        return struct.unpack('<f', data)[0]
    elif len(binstr) == 16:
        data = struct.pack('<H', int(binstr, 2))
        return struct.unpack('<h', data)[0]
    elif binstr.startswith('St'):
        return int(binstr[2])
    else:
        return int(binstr, 2)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        f = sys.stdin
    else:
        f = open(sys.argv[1])

    for line in f:
        cells = line.rstrip().split()
        try:
            int(cells[0])
            cells = cells[2:]
            row = [str(conv_binary(binstr)) for binstr in cells]
        except:
            continue
        print(' '.join(row))
