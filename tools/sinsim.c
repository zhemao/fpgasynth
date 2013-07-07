#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

float factorial(int n)
{
	int i;
	float res = 1;

	for (i = 2; i <= n; i++) {
		res *= i;
	}

	return res;
}

void print_float_hex(FILE * stream, float num)
{
	uint32_t bits;

	memcpy(&bits, &num, sizeof(bits));
	fprintf(stream, "32'h%.8x\n", bits);
}

int main(int argc, char *argv[])
{
	float theta, square, result, power, coeff, fact;
	int prec, i;

	if (argc < 3) {
		fprintf(stderr, "Usage: %s theta prec\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	theta = atof(argv[1]);
	prec = atoi(argv[2]);

	power = theta;
	square = theta * theta;
	result = 0;

	for (i = 0; i <= prec; i++) {
		fact = factorial(2 * i + 1);
		coeff = (i % 2 == 0) ? 1.0 / fact : -1.0 / fact;
		result += coeff * power;
		power *= square;
	}

	print_float_hex(stdout, result);

	return 0;
}
