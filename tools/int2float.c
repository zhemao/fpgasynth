#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* Convert verilog representation of an IEEE 754 single-precision 
 * floating point number into the decimal representation */

int main(void) {
	float real;
	uint32_t bits;

	while (fscanf(stdin, "32'h%x\n", &bits) == 1) {
		memcpy(&real, &bits, sizeof(bits));
		printf("%f\n", real);
	}

	return 0;
}
