.686
.model flat
public _merge
MAX_ARR_LEN equ 8
.data
new_array dd MAX_ARR_LEN dup (?)
.code
_merge proc
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov eax, MAX_ARR_LEN
	mov edx, 0
	mov esi, 2
	div esi
	mov ecx, [ebp + 16]
	cmp eax, ecx
	jl tla

	mov edi, 0
	mov esi, [ebp+8]

	lp: ;loop 
		mov ebx, [esi]
		mov new_array[edi], ebx
		add esi, 4
		add edi, 4
		loop lp

	cmp edx, 0
	jne set_output
	mov ecx, [ebp+16]
	mov esi, [ebp+12]
	inc edx
	jmp lp

	tla: ;too large arrays
		mov eax, 0
		jmp eop

	set_output:
		mov eax, offset new_array

	eop: ;end of the program
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop ebp
		ret
_merge endp
 END