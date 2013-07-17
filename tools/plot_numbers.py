import matplotlib.pyplot as plt
import sys

if __name__ == '__main__':
    if len(sys.argv) < 2:
        f = sys.stdin
    else:
        f = open(sys.argv[1])

    numbers = [float(line.rstrip()) for line in f]

    plt.plot(numbers)
    plt.show()
