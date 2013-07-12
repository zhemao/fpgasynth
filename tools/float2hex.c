#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* Convert floating point numbers from standard input into 
 * the verilog literal of its IEEE 754 single-precision representation */

int main(void) {
	float real;
	uint32_t bits;

	while (fscanf(stdin, "%f\n", &real) == 1) {
		memcpy(&bits, &real, sizeof(bits));
		printf("32'h%.8x\n", bits);
	}

	return 0;
}
