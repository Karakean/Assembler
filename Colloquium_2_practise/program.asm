.686
.model flat
extern _malloc : PROC
public _subtract, _array_copy, _error, _find_min_elem
public _encrypt, _square, _iteration, _float_to_double
public _circle_field, _avg_wd, _sort, _ASCII_to_UTF16
.data 
dtr dq ?
.code

_subtract PROC
	push ebp
	mov ebp, esp ;prolog
	push ebx
	push edx
	push esi

	mov edx, [ebp+8]
	mov eax, [edx]

	mov edx, [ebp+12]
	mov ebx, [edx]
	mov esi, [ebx]

	sub eax, esi

	pop esi
	pop edx
	pop ebx
	pop ebp
	ret
_subtract ENDP

_array_copy PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	push ecx
	push edx
	mov ebx, [ebp+8]
	mov ecx, [ebp+12]
	sub esp, 4
	mov [esp], ecx

	mov eax, 4
	mul ecx
	push eax ;I assume that result is only in eax, not in edx:eax
	call _malloc
	add esp, 4
	mov ecx, [esp]
	add esp, 4
	mov edx, eax
	mov edi, 0
	mov esi, 0

	lp:
		mov eax, [ebx+esi]
		bt eax, 0
		jnc evenn
		mov [edx+edi], dword ptr 0
		jmp continue
		evenn:
		mov [edx+edi], eax
		continue:
		add esi, 4
		add edi, 4
	loop lp
	
	mov eax, edx

	pop edx
	pop ecx
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_array_copy ENDP

_error PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ecx
	mov esi, [ebp+8]
	mov ecx, 0

	count:
		mov al, byte ptr [esi + ecx]
		inc ecx
		cmp al, 0
		je continue
	jmp count

	continue:
		add ecx, 5
		push ecx
		call _malloc
		mov ecx, [esp]
		sub ecx, 5
		add esp, 4
		push eax
		mov edi, eax
		dec ecx

	lp:
		mov al, byte ptr [esi]
		mov byte ptr [edi], al
		inc esi
		inc edi
	loop lp

	mov byte ptr[edi], 'B'
	mov byte ptr[edi+1], 88h
	mov byte ptr[edi+2], 0a5h
	mov byte ptr[edi+3], 'd'
	mov byte ptr[edi+4], '.'
	mov byte ptr[edi+5], 0

	pop eax

	pop ecx
	pop edi
	pop esi
	pop ebp
	ret
_error ENDP

_find_min_elem PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ecx
	mov esi, [ebp+8]
	mov ecx, [ebp+12]
	mov eax, [esi]
	mov edi, esi

	lp:
		cmp eax, [esi]
		jg new_min
		add esi, 4
		loop lp
		jmp continue

		new_min:
		mov eax, [esi]
		mov edi, esi
		add esi, 4
		loop lp

	continue:
	mov eax, edi

	pop ecx
	pop edi
	pop esi
	pop ebp
	ret
_find_min_elem ENDP

_encrypt PROC
	push ebp
	mov ebp, esp
	push esi
	push ebx
	push edx
	mov esi, [ebp+8]

	mov eax, 52525252h

	lp:
		mov bl, byte ptr [esi]
		cmp bl, 0
		jz endlp
		xor bl, al
		mov byte ptr [esi], bl

		bt eax, 30
		setc cl
		bt eax, 31
		setc dl
		xor cl, dl
		shl eax, 1
		cmp cl, 0
		jz continue
		bts eax, 0
		continue:
		inc esi
	jmp lp


	endlp:
	pop edx
	pop ebx
	pop esi
	pop ebp
	ret
_encrypt ENDP

_square PROC
push ebp
mov ebp, esp
push ebx
mov ebx, [ebp+8]

cmp ebx, 1
je one
jl zero

sub ebx, 2
push ebx
call _square
add esp, 4
add ebx, 2
lea ebx, [eax+4*ebx-4]
mov eax, ebx
jmp continue

one:
mov eax, 1
jmp continue
zero:
mov eax, 0

continue:
pop ebx
pop ebp
ret
_square ENDP

_iteration PROC
	push ebp
	mov ebp, esp

	mov al, [ebp+8]
	sal al, 1
	jc finish
	inc al
	push eax
	call _iteration
	add esp, 4
	pop ebp
	ret

	finish:
	rcr al, 1
	pop ebp
	ret
_iteration ENDP

_float_to_double PROC
	push ebp
	mov ebp, esp
	push esi
	push ebx
	mov esi, [ebp+8]
	mov eax, [esi]

	mov ebx, eax
	and ebx, 7F800000h
	shr ebx, 23
	add ebx, 896 ;1023-127
	shl ebx, 20
	bt eax, 31
	jnc continue
	bts ebx, 31

	continue:
	mov ecx, 3
	mov edx,0
	and eax, 007FFFFFh
	lp:
		shr eax, 1
		rcr edx, 1
	loop lp
	or eax, ebx
	mov dword ptr [dtr+4], eax
	mov dword ptr [dtr], edx

	mov eax, offset dtr
	pop ebx
	pop esi
	pop ebp
	ret
_float_to_double ENDP

_circle_field PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]

	fld dword ptr [eax]
	fst st(1)
	fmulp
	fldpi
	fmulp
	fstp dword ptr [eax]

	pop ebp
	ret
_circle_field ENDP

_avg_wd PROC
push ebp
mov ebp, esp
push esi
push edi
mov ecx, [ebp+8]
mov esi, [ebp+12]
mov edi, [ebp+16]
finit

fldz
fldz
lp:
	fld dword ptr [esi]
	fld dword ptr [edi]
	fadd st(3), st(0)
	fmulp
	faddp
	add esi, 4
	add edi, 4
loop lp
fxch
fdiv

pop edi
pop esi
pop ebp
ret
_avg_wd ENDP

_sort PROC
push ebp
mov ebp, esp
sub esp, 8
push esi
push edi
push ebx
mov ebx, [ebp+8]
mov eax, [ebp+12]
dec eax
mov dword ptr [ebp-4], eax

mov ecx, 0
lp:
	mov esi, 0
	mov eax, [ebp-4]
	sub eax, ecx
	mov [ebp-8], eax
	lp2:
		mov eax, [ebx+8*esi+4]
		mov edx, [ebx+8*esi+12]
		cmp eax, edx
		jb continue
		ja swap

		mov eax, [ebx+8*esi]
		mov edx, [ebx+8*esi+8]
		cmp eax, edx
		jna continue

		mov eax, [ebx+8*esi+4]
		mov edx, [ebx+8*esi+12]

		swap:
		mov [ebx+8*esi+4], edx
		mov edx, [ebx+8*esi+8]
		push dword ptr [ebx+8*esi]
		mov [ebx+8*esi], edx
		mov [ebx+8*esi+12], eax
		pop eax
		mov [ebx+8*esi+8], eax

		continue:
		inc esi
		cmp esi, [ebp-8]
	jne lp2
	inc ecx
	cmp ecx, [ebp-4]
jne lp

mov edx, [ebx+8*ecx+4]
mov eax, [ebx+8*ecx]

pop ebx
pop edi
pop esi
add esp, 8
pop ebp
ret
_sort ENDP

_ASCII_to_UTF16 PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov esi, [ebp+8]
	mov eax, [ebp+12]
	mov ecx, 2
	mul ecx
	push eax
	call _malloc
	add esp, 4
	mov edi, eax
	mov ecx, [ebp+12]

	mov ebx, 0
	lp:
		mov al, [esi+ebx]
		mov byte ptr [edi+2*ebx], al
		mov byte ptr [edi+2*ebx+1], 0
		inc ebx
	loop lp

	mov eax, edi

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_ASCII_to_UTF16 ENDP

END