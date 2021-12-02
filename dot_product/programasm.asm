.686
.model flat
public _dot_product
.code
_dot_product PROC 
	push ebp
	mov ebp, esp
	push ebx
	push edx
	push esi
	push edi

	sub esp, 4
	mov [esp], dword ptr 0
	mov ecx, [ebp+16]
	mov ebx, [ebp+12]
	mov edx, [ebp+8]

	ptl:
		mov esi, [ebx]
		push edx
		mov edi, [edx]
		mov eax, esi
		imul edi
		pop edx
		add [esp], eax
		add ebx, 4
		add edx, 4
	loop ptl
	mov eax, [esp]

	add esp,4
	pop edi
	pop esi
	pop edx
	pop ebx
	pop ebp
	ret
_dot_product ENDP
 END
