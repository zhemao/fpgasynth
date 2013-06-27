import math
import sys

def taylor_series(n):
    return [1.0 / math.factorial(2 * i + 1) 
            if i % 2 == 0 else -1.0 / math.factorial(2 * i + 1)
            for i in range(0, n)]

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " n")
        sys.exit(1)
    
    n = int(sys.argv[1])

    for num in taylor_series(n):
        print(num)
