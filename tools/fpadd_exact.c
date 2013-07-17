#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int main(void) {
	float a, b;

	while (fscanf(stdin, "%f %f\n", &a, &b) == 2) {
		print_float_hex(stdout, a + b);
	}

	return 0;
}
