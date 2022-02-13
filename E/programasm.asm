.686
.model flat
public _shl_128, _mul_24, _get_RPK
public _get_actual_distribution, _create_benford_distribution_asm, _check_data
public _count_counterfeit
extern _malloc : PROC
;extern _VirtualAlloc : PROC
.data
arr db 16 dup (0)
arr2 db 16 dup (0)
decoder db 'BCDFGHJKMPQRTVWXY2346789'
.code
_shl_128 PROC
	push ebp
	mov ebp, esp
	pusha
	mov esi, [ebp+8]
	mov eax, [esi]
	mov ebx, [esi+4]
	mov ecx, [esi+8]
	mov edx, [esi+12]
	mov edi, [ebp+12]

	lp:
		shl eax, 1
		rcl ebx, 1
		rcl ecx, 1
		rcl edx, 1
		dec edi
		cmp edi, 0
	jnz lp

	mov [esi], eax
	mov [esi+4], ebx
	mov [esi+8], ecx
	mov [esi+12], edx

	popa
	pop ebp
	ret
_shl_128 ENDP

_mul_24 PROC
	push ebp
	mov ebp, esp
	sub esp, 16
	pusha
	mov esi, [ebp+8]
	mov edi, [ebp+12]
	
	push dword ptr 4
	mov ecx, 4
	rep movsd
	sub esi, 16
	sub edi, 16
	push edi
	call _shl_128
	add esp, 8
	
	mov edx, 0
	mov ecx, 4
	tmpsave:
		mov eax, [edi+edx]
		mov [ebp+edx-16], eax
		add edx, 4
	loop tmpsave
	
	push dword ptr 3
	mov ecx, 4
	rep movsd
	sub esi, 16
	sub edi, 16
	push edi
	call _shl_128
	add esp, 8
	
	mov esi, 0
	mov ecx, 4
	addnumbers:
		mov eax, [edi+esi]
		mov edx, [ebp+esi-16]
		add eax, edx
		mov [edi+esi], eax
		add esi, 4
	loop addnumbers

	popa
	add esp, 16
	pop ebp
	ret
_mul_24 ENDP

_get_RPK PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov ebx, [ebp+8]
	
	mov ecx, 29
	lp:
		mov al, [ebx+ecx-1]
		cmp al, '2'
		jb not_a_symbol
		cmp al, 'Y'
		ja not_a_symbol
		jmp find_symbol
		found:
		pop ecx
		mov edx, offset arr
		push offset arr2
		push offset arr
		call _mul_24
		push esi
		push edi
		push ecx
		mov esi, offset arr2
		mov edi, offset arr
		mov ecx, 16
		rep movsb
		pop ecx
		pop edi
		pop esi
		add byte ptr [edx], al
		add esp, 8
	loop lp
	jmp ending

	not_a_symbol:
	loop lp

	find_symbol:
		mov esi, offset decoder
		push ecx
		mov ecx, 24
		mov dl, al
		mov eax, 0
		innerlp:
			cmp dl, [esi+eax]
			je found
			inc eax
		loop innerlp
		pop ecx
		jmp not_a_symbol
	loop find_symbol
	
	ending:
	mov eax, [ebp-8]

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_get_RPK ENDP

_get_actual_distribution PROC
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push esi
	push edi
	mov ebx, [ebp+8]
	mov ecx, [ebp+12]

	push ecx
	push 36
	call _malloc
	add esp, 4
	mov edi, eax
	mov ecx, 36
	mov al, 0
	cld
	rep stosb
	pop ecx
	sub edi, 36

	
	mov ax, [ebx]
	sub ax, 30h
	movzx eax, ax
	dec eax
	add byte ptr [edi+4*eax], 1
	add ebx, 2
	
	mov edx, 1
	lp:
	mov ax, [ebx]
	cmp ax, 2Ch
	jne continue
	cmp word ptr [ebx+2], 0
	je get_d
	add ebx, 2
	mov ax, [ebx]
	sub ax, 30h
	movzx eax, ax
	dec eax
	add dword ptr [edi+4*eax], 1
	inc edx
	loop lp
	continue:
	add ebx, 2
	loop lp

	get_d:
	finit
	mov ecx, 9
	mov esi, 0
	push edx
	fild dword ptr [esp]
	add esp, 4
	innerlp:
	mov eax, [edi+esi]
	push eax
	fild dword ptr [esp]
	fdiv st(0), st(1)
	fstp dword ptr [ebp-4]
	mov eax, [ebp-4]
	mov dword ptr [edi+esi], eax
	add esp, 4
	add esi, 4
	loop innerlp
	fstp st(0)

	mov eax, edi
	pop edi
	pop esi
	pop ebx
	add esp, 4
	pop ebp
	ret
_get_actual_distribution ENDP

_create_benford_distribution_asm PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	;push dword ptr 1
	;push dword ptr 1000h
	;push dword ptr 36
	;push 0
	;call __VirtualAlloc
	;add esp, 16
	push 36
	call _malloc
	add esp, 4
	mov edi, eax

	mov esi, 1
	mov ecx, 9
	lp:
		finit 
		fld1 ;1
		fst st(1) ;1 1
		push esi
		fild dword ptr [esp] ;k
		add esp, 4
		fdivp ;1/k
		faddp ;1+1/k
		fld1 ; 1 1+1/k
		fxch st(1)
		FYL2X
		fld1
		mov eax, 10
		push eax
		fild dword ptr [esp]
		add esp,4
		FYL2X
		fdivp
		fstp dword ptr [edi+4*esi-4]
		inc esi
	loop lp

	mov eax, edi
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_create_benford_distribution_asm ENDP

_check_data PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov esi, [ebp+8]

	mov ecx, 0
	lp:
	mov ax, [esi+2*ecx]
	inc ecx
	cmp ax, 0
	jne lp

	push ecx
	push esi
	call _get_actual_distribution
	add esp, 8
	mov esi, eax

	mov edi, [ebp+8]
	push edi
	call _create_benford_distribution_asm
	add esp, 4
	mov edi, eax

	mov ecx, 9
	finit
	lp1:
		fld dword ptr [esi]
		fld dword ptr [edi]
		fsubp
		fabs
		mov eax, 1
		push eax
		fild dword ptr [esp]
		add esp, 4
		mov eax, 8
		push eax
		fild dword ptr [esp]
		add esp, 4
		fdivp
		fcomi st(0), st(1)
		fstp st(0)
		fstp st(0)
		jb ret1
	loop lp1

	mov eax, 0
	jmp finish
		
	ret1:
	mov eax, 1	
		
	finish:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_check_data ENDP

_count_counterfeit PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov ebx, [ebp+8]
	mov cl, [ebp+12]
	
	xor esi, esi
	xor edx, edx
	lp:
	mov al, [ebx]
	cmp al, 0
	je finish
	cmp al, '{'
	je new_object
	inc ebx
	jmp lp

	new_object:
	add ebx, 9
	lp1:
	mov al, [ebx]
	cmp al, ','
	je continue
	xor al, cl
	add dl, al
	inc ebx
	jmp lp1

	continue:
	add ebx, 11
	mov al, [ebx]
	shl al, 4
	inc ebx
	add al, [ebx]
	cmp al, dl
	setne dl
	movzx edx, dl
	add esi, edx
	add ebx, 2
	jmp lp


	finish:
	mov eax, esi
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_count_counterfeit ENDP

END