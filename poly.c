//
// Exmaple 8 bit lfsr
//
#include <stdlib.h>
#include <stdio.h>
int main(int argc, char *argv[]){

    unsigned int val = 1;
    unsigned int nbit;
    for (int i=1; i<=256; i++){
	nbit = ((val >> 7) & 1) ^ ((val >>5) & 1) ^ ((val >>4) & 1) ^ ((val >>3) & 1);
	val = ((val << 1) | nbit) & 0xff;
	printf("%d : %02x\n", i, val);
    }
}
