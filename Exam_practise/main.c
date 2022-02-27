#include <stdio.h>
#include<xmmintrin.h>
void shl_128(__m128* a, char n);
void mul_24(__m128* in, __m128* out);
unsigned int get_RPK(char* PK);
unsigned int check_data(wchar_t* data);
float* get_actual_distribution(wchar_t* data, unsigned int len);
float* create_benford_distribution_asm();
unsigned int count_counterfeit(char* input, char key);
int main() {
	__m128 a;
	a.m128_i32[0] = 0x40000000;
	a.m128_i32[1] = 0x40000000;
	a.m128_i32[2] = 0x40000000;
	a.m128_i32[3] = 0x40000000;
	printf("%d %d %d %d\n", a.m128_i32[3], a.m128_i32[2],
		a.m128_i32[1], a.m128_i32[0]);
	shl_128(&a, 3);
	printf("%d %d %d %d\n", a.m128_i32[3], a.m128_i32[2],
		a.m128_i32[1], a.m128_i32[0]);
	
	__m128 b;
	mul_24(&a, &b);
	printf("%d %d %d %d\n", b.m128_i32[3], b.m128_i32[2],
		b.m128_i32[1], b.m128_i32[0]);

	char pk[] = "FFFFF-GGGGG-HHHHH-JJJJJ-KKKKK";
	unsigned int c = get_RPK(pk);
	printf("%u\n", c);

	wchar_t data[] = L"3192480123,3442,341242134,367654,63442,4233254,52,534,533245,325,";
	float* d = get_actual_distribution(data, 66);
	printf("%f %f %f %f %f %f\n", d[0], d[1], d[2], d[3], d[4], d[5]);
	float* e = create_benford_distribution_asm();
	printf("%f %f %f %f %f %f\n", e[0], e[1], e[2], e[3], e[4], e[5]);
	unsigned int f = check_data(data);
	if (f)
		printf("SOMETHING IS WRONG.\n");
	else
		printf("OK.\n");

	char input[] = ";{\"tekst\":sdasd,\"szyfr\":0x34};{\"tekst\":ssss,\"szyfr\":0x47};{\"tekst\":foo,\"szyfr\":0xAB};";
	//char input2[] = ";{\"tekst\":sdasd,\"szyfr\":0x2E};";
	unsigned int g = count_counterfeit(input, 'a');
	printf("%u", g);


	return 0;
}
