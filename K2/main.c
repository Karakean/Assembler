#include <stdio.h>
int subtract(int* odjemna, int** odjemnik);
int* array_copy(int arr[], unsigned int n);
char* error(char* text);
int* find_min_elem(int arr[], int n);
void encrypt(char* text);
unsigned int square(unsigned int a);
unsigned char iteration(unsigned char a);
double* float_to_double(float* x);
void circle_field(float* x);
float avg_wd(int n, void* arr, void* weight);
int main()
{
	/*int a, b, * ptr, result;
	ptr = &b;
	a = -21; b = -25;
	result = subtract(&a, &ptr);
	printf("%d", result);*/
	
	/*int arrS[] = { 1,2,3,4,5,6,7,8,9 };
	int* arrD = array_copy(arrS, 9);
	for (int i = 0; i < 9; i++) {
		printf("%d ", i[arrD]);
	}*/

	/*char* txt = "Incorrect syntax. ";
	char* err = error(txt);
	printf("%s\n", err);*/

	/*int arr[] = { 2,6,3,7,4,5,9 };
	int* smallest;
	smallest = find_min_elem(arr, 7);
	printf("%d\n", *smallest);*/

	/*char text[] = "dziubich";
	encrypt(text);
	printf("%s\n", text);*/

	/*unsigned int a = 12;
	unsigned int b = square(a);
	printf("%u", b);*/

	/*unsigned char w = iteration(32);
	printf("%c", w);*/

	/*float number = 3.3f;
	float* f = &number;
	double* d;
	d = float_to_double(f);
	printf("%lf", *d);*/

	/*float x = 3;
	circle_field(&x);
	printf("%f", x);*/

	float grades[] = { 3.0f,3.5f,4.0f,4.5f,5.0f };
	float weights[] = { 2, 3, 4, 5, 6 };
	float average = avg_wd(5, grades, weights);
	printf("%f", average);

	return 0;
}