; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
	; przechowanie używanych rejestrów
	push ax
	push bx
	push cx
	push dx
	push es
	; wpisanie adresu pamięci ekranu do rejestru ES - pamięć
	; ekranu dla trybu tekstowego zaczyna się od adresu B8000H,
	; jednak do rejestru ES wpisujemy wartość B800H,
	; bo w trakcie obliczenia adresu procesor każdorazowo mnoży
	; zawartość rejestru ES przez 16
	mov ax, 0B800h ;adres pamięci ekranu
	mov es, ax
	; zmienna 'licznik' zawiera adres bieżący w pamięci ekranu
	mov bx, cs:licznik
	; przesłanie do pamięci ekranu kodu ASCII wyświetlanego znaku
	; i kodu koloru: biały na czarnym tle (do następnego bajtu)
	mov al, cs:znak
	mov byte PTR es:[bx], al ; kod ASCII
	mov byte PTR es:[bx+1], 00000111B ; kolor
	; zwiększenie o 2 adresu bieżącego w pamięci ekranu
	mov al, cs:kierunek
	cmp al, 72 
	je gora
	cmp al, 75 
	je lewo
	cmp al, 77 
	je prawo
	cmp al, 80 
	je dol
	jmp wysw_dalej

	gora:
		cmp bx, 160
		jb wysw_dalej
		sub bx, 160
		mov cs:znak, 5eh
		jmp wysw_dalej

	lewo:
		mov ax, bx
		mov dx, 0
		mov cx, 160
		div cx
		cmp dx, 0
		jz wysw_dalej
		sub bx, 2
		mov cs:znak, 3ch
		jmp wysw_dalej

	prawo:
		mov ax, bx
		add ax, 2
		mov dx, 0
		mov cx, 160
		div cx
		cmp dx, 0
		jz wysw_dalej
		add bx, 2
		mov cs:znak, 3eh
		jmp wysw_dalej

	dol:
		cmp bx, 3840
		ja wysw_dalej
		add bx, 160
		mov cs:znak, 76h

	wysw_dalej:
	mov cs:licznik,bx
	; odtworzenie rejestrów
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	; skok do oryginalnej procedury obsługi przerwania zegarowego
	jmp dword PTR cs:wektor8
	; dane programu ze względu na specyfikę obsługi przerwań
	; umieszczone są w segmencie kodu
	licznik dw 320 ; wyświetlanie począwszy od 2. wiersza
	wektor8 dd ?
	znak db '*'
obsluga_zegara ENDP

obsluga_klawiatury PROC
	push ax
	push bx
	push es

	in al, 60h
	cmp al, 72
	je strzalka
	cmp al, 75
	je strzalka
	cmp al, 77
	je strzalka
	cmp al, 80
	je strzalka
	jmp dalej

	strzalka:
	mov cs:kierunek, al

	dalej:
	pop es
	pop bx
	pop ax

	jmp dword ptr cs:wektor9

	wektor9 dd ?
	kierunek db ?
obsluga_klawiatury ENDP

	;============================================================
	; program główny - instalacja i deinstalacja procedury
	; obsługi przerwań
	; ustalenie strony nr 0 dla trybu tekstowego
	zacznij:
	mov al, 0
	mov ah, 5
	int 10

	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS
	; odczytanie zawartości wektora nr 8 i zapisanie go
	; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty
	; począwszy od adresu fizycznego 8 * 4 = 32)
	mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
	mov cs:wektor8, eax
	; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; część segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	cli ; zablokowanie przerwań
	; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	sti ;odblokowanie przerwań
	; oczekiwanie na naciśnięcie klawisza 'x'

	mov ax, 0
	mov ds,ax
	mov eax,ds:[36]
	mov cs:wektor9, eax
	mov ax, SEG obsluga_klawiatury
	mov bx, OFFSET obsluga_klawiatury
	cli
	mov ds:[36], bx
	mov ds:[38], ax
	sti

	aktywne_oczekiwanie:
	mov ah,1
	int 16H
	; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli
	; naciśnięto jakiś klawisz
	jz aktywne_oczekiwanie
	; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0)
	; do rejestru AL
	mov ah, 0
	int 16H
	cmp al, 'x' ; porównanie z kodem litery 'x'
	jne aktywne_oczekiwanie ; skok, gdy inny znak
	; deinstalacja procedury obsługi przerwania zegarowego
	; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ; przesłanie wartości oryginalnej
	; do wektora 8 w tablicy wektorów
	; przerwań
	sti
	mov eax, cs:wektor9
	cli
	mov ds:[36], eax
	sti
	; zakończenie programus
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij
