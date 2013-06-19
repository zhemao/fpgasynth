CFLAGS=-Wall -O2

TOOLS=float2int

all: $(TOOLS)

%: %.c
	$(CC) $(LDFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(TOOLS)

.PHONY: clean
