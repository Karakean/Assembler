#define MAX_VECTOR_SIZE 100
#include <stdio.h>
int dot_product(int* arr1, int* arr2, int n);
int main()
{
	int n, arr1[MAX_VECTOR_SIZE], arr2[MAX_VECTOR_SIZE], i;
	printf("Enter the size of both vectors: ");
	scanf_s("%d", &n);

	printf("Enter coordinations of the first vector: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &arr1[i]);
	}
	
	printf("Enter coordinations of the second vector: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &arr2[i]);
	}

	int result = dot_product(arr1, arr2, n);
	printf("The dot product is: %d\n", result);

	return 0;
}

