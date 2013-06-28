CFLAGS=-Wall -O2

TOOLS=float2int int2float sinsim gensincoeff

all: $(TOOLS)

%: %.c
	$(CC) $(LDFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(TOOLS)

.PHONY: clean
