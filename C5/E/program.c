#include <stdio.h>
#include<xmmintrin.h>
void sum(char* arrA, char* arrB, char* arrC);
void int2float(int* arr1, float* arr2);
void addsub(float* arr);
void addsse(float* a);
__m128 mul_at_once(__m128 one, __m128 two);
float find_max_range(float v, float alpha);
__m128 quick_max(short int* t1, short int* t2);
float cone_volume(unsigned int big_r, unsigned int small_r, float h);
void quadratic_equation(float a, float b, float c, float* x1, float* x2);
int main()
{
	/*char arr_A[16] = { -128, -127, -126, -125, -124, -123, -122,
-121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char arr_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3,
	3, 3, 3, 3, 3, 3, 3, 3 };
	char arr_C[16];
	sum(arr_A, arr_B, arr_C);
	for (int i = 0; i < 16; i++) {
		printf("%d ", i[arr_C]);
	}*/

	/*int a[2] = { -17, 24 };
	float r[4];
	int2float(a, r);
	printf("\n%f %f\n", r[0], r[1]);*/

	/*float arr[4] = { 27.5,143.57,2100.0, -3.51 };
	printf("\n%f %f %f %f\n", arr[0],
		arr[1], arr[2], arr[3]);
	addsub(arr);
	printf("\n%f %f %f %f\n", arr[0],
		arr[1], arr[2], arr[3]);*/

	/*float result[4];
	addsse(result);
	printf("\nResult = %f %f %f %f\n",
		result[0], result[1], result[2], result[3]);*/

	//__m128 one, two;
	//one.m128_i32[0] = 2;
	//one.m128_i32[1] = 4;
	//one.m128_i32[2] = 6;
	//one.m128_i32[3] = 8;
	//two.m128_i32[0] = 1;
	//two.m128_i32[1] = 2;
	//two.m128_i32[2] = 3;
	//two.m128_i32[3] = 4;
	//__m128 result = mul_at_once(one , two);
	//printf("%d %d %d %d\n", result.m128_i32[0], result.m128_i32[1], result.m128_i32[2], result.m128_i32[3]);

	/*float result = find_max_range(1.1f, 0.7854f);
	printf("%f\n", result);*/

	short int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	short int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	__m128 t1 = quick_max(val1, val2);
	int i;
	for (i = 0; i < 8; i++) {
		printf("%hi ", i[t1.m128_i16]);
	}

	float result = cone_volume(8, 4, 6.1f);
	printf("\n%f\n", result);

	float x1, x2;
	quadratic_equation(1.0f, 4.0f, 3.0f, &x1, &x2);
	printf("%f %f\n", x1, x2);

	return 0;
}