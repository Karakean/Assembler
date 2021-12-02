#define MAX_VECTOR_SIZE 100
#include <stdio.h>
int dot_product(int* arr1, int* arr2, int n);
int main()
{
	int n, tab1[MAX_VECTOR_SIZE], tab2[MAX_VECTOR_SIZE], i;
	printf("Enter the size of both vectors: ");
	scanf_s("%d", &n);

	printf("Enter coordinations of the first vector: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &tab1[i]);
	}
	
	printf("Enter coordinations of the second vector: \n");
	for (i = 0; i < n; i++) {
		scanf_s("%d", &tab2[i]);
	}

	int wynik = dot_product(tab1, tab2, n);
	printf("The dot product is: %d\n", wynik);

	return 0;
}