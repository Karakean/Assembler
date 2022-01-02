#include <stdio.h>
#include <stdlib.h>
float series_sum(float x, int n);
int main()
{
	float x;
	int n;
	scanf_s("%f\n%d", &x,&n);
	float result = series_sum(x,n);
	printf("%f", result);
	return 0;
}