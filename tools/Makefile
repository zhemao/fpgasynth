CFLAGS=-Wall -O2

TOOLS=float2hex hex2float sinsim gensincoeff fpadd_exact fpmult_exact

all: $(TOOLS)

%: %.c common.h
	$(CC) $(LDFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(TOOLS)

.PHONY: clean
