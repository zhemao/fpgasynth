#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int main(void) {
	float real;
	uint32_t bits;

	while (fscanf(stdin, "%x\n", &bits) == 1) {
		memcpy(&real, &bits, sizeof(bits));
		printf("%f\n", real);
	}

	return 0;
}
