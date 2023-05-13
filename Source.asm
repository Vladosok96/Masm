; #########################################################################

	.486
	option casemap :none   ; case sensitive

; #########################################################################

	include			C:\masm32\include\masm32rt.inc

; #########################################################################

.data
	
	ControllerInfo		db "KR1802VS1 (F0 = 1)", 10, 13, 0
	DAPrompt   			db "Enter DA(0-7) >>>", 0
	DBPrompt			db "Enter DB(0-7) >>>", 0
	inputFPrompt		db "Enter F(0-7) >>>", 0

	print8String		db "%8s", 0
	scanInteger			db "%d", 0
	printInteger   		db "%d ", 10, 13, 0
	printFloat			db "%f ", 0
	printNormal   		db "%de%d ", 0

	DAInput				db "00000000", 0
	DBInput				db "00000000", 0
	DAbyte				db 0
	DBbyte				db 0
	Fbyte				db 0

.code

start:

	invoke		crt_printf, offset ControllerInfo, 0	
	
	invoke		crt_printf, offset DAPrompt, 0	
	invoke		crt_scanf, offset print8String, offset DAInput
	
	mov ebx, 0
	mov esi, offset DAInput
    mov ecx, 8
DA_loop_start:
	shl ebx, 1
    lodsb
	cmp al, 31h
	jne DA_next
	inc ebx
DA_next:
    loop DA_loop_start
	mov DAbyte, bl


	invoke		crt_printf, offset DBPrompt, 0	
	invoke		crt_scanf, offset print8String, offset DBInput

	mov ebx, 0
	mov esi, offset DBInput
    mov ecx, 8
DB_loop_start:
	shl ebx, 1
    lodsb
	cmp al, 31h
	jne DB_next
	inc ebx
DB_next:
    loop DB_loop_start
	mov DBbyte, bl

	mov eax, 0
	mov ebx, 0
	mov al, DAbyte
	mov bl, DBbyte
	add al, bl

	push 0
	call ExitProcess

	; --------------------------------------------------------
	; The following are the same function calls using MASM
	; "invoke" syntax. It is clearer code, it is type checked
	; against a function prototype and it is less error prone.
	; --------------------------------------------------------

	; invoke MessageBox,0,ADDR szMsg,ADDR szDlgTitle,MB_OK
	; invoke ExitProcess,0

end start