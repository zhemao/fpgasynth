CFLAGS=-Wall -O2

TOOLS=float2hex hex2float sinsim gensincoeff

all: $(TOOLS)

%: %.c
	$(CC) $(LDFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(TOOLS)

.PHONY: clean
