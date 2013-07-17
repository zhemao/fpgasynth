#include "common.h"

/* Convert floating point numbers from standard input into 
 * the verilog literal of its IEEE 754 single-precision representation */

int main(void) {
	float real;

	while (fscanf(stdin, "%f\n", &real) == 1) {
		print_float_hex(stdout, real);
	}

	return 0;
}
