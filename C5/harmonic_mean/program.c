#include <stdio.h>
float harmonic_mean(float* arr, unsigned int n);
int main()
{
	float numbers[5] = { 3.0f, 4.5f, 2.5f, 2.0f, 1.5f };
	float result = harmonic_mean(numbers, 5);
	printf("%f", result);
	return 0;
}