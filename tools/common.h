#ifndef __TOOLS_COMMON_H__
#define __TOOLS_COMMON_H__

#include <stdio.h>
#include <string.h>
#include <stdint.h>

inline void print_float_hex(FILE * stream, float num)
{
	uint32_t bits;

	memcpy(&bits, &num, sizeof(bits));
	fprintf(stream, "32'h%.8x\n", bits);
}
#endif
