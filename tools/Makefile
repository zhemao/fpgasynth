CFLAGS=-Wall -O2

TOOLS=float2int int2float gensincoeff

all: $(TOOLS)

%: %.c
	$(CC) $(LDFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(TOOLS)

.PHONY: clean
