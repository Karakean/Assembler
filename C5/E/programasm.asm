.686
.XMM
.model flat
public _sum, _int2float, _addsub, _addsse, _mul_at_once 
public _find_max_range, _quick_max, _cone_volume, _quadratic_equation
.data 
ALIGN 16
arr1 dd 1.0, 1.0, 1.0, 1.0
arrA dd 1.0, 2.0, 3.0, 4.0
arrB dd 2.0, 3.0, 4.0, 5.0
arrC dd 3.0, 4.0, 5.0, 6.0
one dd 1.0
two dd 2.0
three dd 3.0
four dd 4.0
const_g dd 9.81
x1 dd ?
x2 dd ?
.code
_sum PROC
	 push ebp
	 mov ebp, esp ;prolog
	 push ebx
	 push esi
	 push edi
	 mov esi, [ebp+8] ;first arr
	 mov ebx, [ebp+12] ;sec arr
	 mov edi, [ebp+16] ;dest arr

	 movups xmm5, [esi]
	 movups xmm6, [ebx]
	 paddsb xmm5, xmm6
	 movups [edi], xmm5

	 pop edi
	 pop esi
	 pop ebx
	 pop ebp
	 ret
_sum ENDP

_int2float PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	mov esi, [ebp+8] ;int arr address
	mov edi, [ebp+12] ;floar arr adress

	cvtpi2ps xmm5, qword PTR [esi]
	movups [edi], xmm5

	pop edi
	pop esi
	pop ebp
	ret
_int2float ENDP

_addsub PROC
	push ebp
	mov ebp, esp
	push esi
	mov esi, [ebp+8]

	movups xmm5, [esi]
	;movups xmm6, arr1
	addsubps xmm5, xmm6
	movups [esi], xmm5

	pop esi
	pop ebp
	ret
_addsub ENDP

_addsse PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]

	movaps xmm2, arrA
	movaps xmm3, arrB
	movaps xmm4, arrC
	addps xmm2, xmm3
	addps xmm2, xmm4
	movups [eax], xmm2

	pop ebp
	ret
_addsse ENDP

_mul_at_once PROC
	pmulld xmm0, xmm1
	ret
_mul_at_once ENDP

_find_max_range PROC
	push ebp
	mov ebp, esp

	fld dword ptr [ebp+8] ;v0
	fst st(1)
	fmulp
	fld two
	fmulp
	fld const_g
	fdivp st(1), st(0)
	fld dword ptr [ebp+12] ;alpha
	fsincos
	fmulp
	fmulp

	pop ebp
	ret
_find_max_range ENDP

_quick_max PROC
	push ebp
	mov ebp, esp
	push esi
	push ebx
	mov esi, [ebp+8] ;val1
	mov ebx, [ebp+12] ;val2

	movups xmm0, [esi]
	movups xmm1, [ebx]
	PMAXSW xmm0, xmm1

	pop ebx
	pop esi
	pop ebp
	ret
_quick_max ENDP

_cone_volume PROC
	push ebp
	mov ebp, esp

	fild dword ptr [ebp+8] ;R
	fst st(1)
	fmul st(1), st(0) ;R^2
	fild dword ptr [ebp+12] ;r
	fld st(0)
	fmul st(2), st(0) ;R*r
	fmulp ;r^2
	faddp ;R*r + r^2
	faddp ;R^2 + R*r + r^2
	
	fld one
	fld three
	fdivp ;1/3
	fldpi
	fmulp ;1/3*pi
	fld dword ptr [ebp+16] ;h
	fmulp ;1/3*pi*h

	fmulp ;1/3*pi*h*(R^2+R*r+r^2)

	pop ebp
	ret
_cone_volume ENDP

_quadratic_equation PROC
	push ebp
	mov ebp, esp
	
	fld dword ptr [ebp+12] ;b
	fst st(1) ;b
	fmulp ;b^2
	fld four
	fld dword ptr [ebp+8] ;a
	fmulp ;4*a
	fld dword ptr [ebp+16] ;c
	fmulp ;4*a*c
	fsubp ;b^2-4*a*c, delta
	fsqrt ;sqrt(b^2-4*a*c), sqrt(delta)
	fld dword ptr [ebp+12] ;b
	fchs ;-b
	fld st(0) ;-b
	fsub st(0), st(2) ;-b-sqrt(delta)
	fxch
	faddp st(2), st(0) ;sqrt(delta)-b
	fld dword ptr [ebp+8] ;a
	fld two
	fmulp ;2*a
	fdiv st(2),st(0)
	fdivp st(1),st(0)

	fstp x1
	fstp x2

	mov eax, [ebp+20]
	mov edx, x1
	mov [eax], edx

	mov eax, [ebp+24]
	mov edx, x2
	mov [eax], edx

	pop ebp
	ret
_quadratic_equation ENDP

END
