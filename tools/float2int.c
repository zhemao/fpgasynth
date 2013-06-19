#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int main(void) {
	float real;
	uint32_t bits;

	while (fscanf(stdin, "%f\n", &real) == 1) {
		memcpy(&bits, &real, sizeof(bits));
		printf("%x\n", bits);
	}

	return 0;
}
