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

int main(int argc, char *argv[])
{
	float theta, square, result, power, coeff, fact;
	int prec, i;
	uint32_t result_bits;

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

	memcpy(&result_bits, &result, sizeof(result));

	printf("32'h%.8x\n", result_bits);

	return 0;
}
