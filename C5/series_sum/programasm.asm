.686
.model flat
public _series_sum
.data
x_val dd ?
one dd 1.0
.code
_series_sum PROC ; 1+(x/1)+(x^2/(1*2))+(x^3/(1*2*3))+...
	mov eax, [esp+4]
	mov x_val, eax
	mov ecx, [esp+8]
	
	finit
	fld one ;sum
	dec ecx
	fldz ;loop counter, 0 at beginning
	fld one ;just one
	lp: ;loop
		fld x_val ;
		fmulp st(1),st(0) ;x^(i), nominator
		fld one
		faddp st(2), st(0) ;1*2*..*n, denominator
		fdiv st(0), st(1) ;nominator/denominator
		fadd st(2), st(0) ;sum
	loop lp

	fstp st(0)
	fstp st(0)
	ret
_series_sum ENDP
END