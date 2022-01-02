.686
.model flat
public _harmonic_mean
.data
value dd ?
nn dd ? ;numbers number
one dd 1.0
.code
_harmonic_mean PROC
	mov ecx, [esp+8]
	mov nn, ecx
	mov ebx, [esp+4] ;array address
	;fld one ;to reciprocal
	finit
	fldz ;beginning sum

	lp: ;loop
		mov eax, [ebx]
		mov value, eax
		fld one
		fld dword ptr value
		fdivp st(1), st(0)
		faddp st(1), st(0)
		add ebx, 4
	loop lp

	fild nn
	fdiv st(0),st(1)
	fxch
	fstp st(0)

	ret
_harmonic_mean ENDP
END