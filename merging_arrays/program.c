#define MAX_ARRAY_SIZE 100
#include <stdio.h>
int* merge(int* arr1, int* arr2, int n);
int main()
{
	int n, arr1[MAX_ARRAY_SIZE], arr2[MAX_ARRAY_SIZE], i;
	printf("Enter the size of arrays: ");
	scanf_s("%d", &n);

	printf("Enter values of the first array: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &arr1[i]);
	}

	printf("Enter values of the second array: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &arr2[i]);
	}

	int* result = merge(arr1, arr2, n);

	if (!result) {
		printf("The given size of arrays is too large.\n");
		return -1;
	}

	printf("The merged array: ");
	for (i = 0; i < 2*n; i++) {
		printf("%d ", result[i]);
	}

	return 0;
}