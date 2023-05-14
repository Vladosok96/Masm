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
	FPrompt				db "Enter F(0-7) >>>", 0
	CIPrompt			db "Enter CI >>>", 0

	scanf8String		db "%8s", 0
	scanInteger			db "%d", 0
	printInteger   		db "%d ", 10, 13, 0
	printFloat			db "%f ", 0
	printNormal   		db "%de%d ", 0

	DAInput				db "00000000", 0
	DBInput				db "00000000", 0
	FInput				db "00000000", 0
	CIInput				db "00000000", 0
	DAbyte				db 0
	DBbyte				db 0
	Fbyte				db 0
	CIbyte				db 0

	DAOutput			db "00000000", 10, 13, 0
	DBOutput			db "00000000", 10, 13, 0
	DAResult   			db "Result DA(0-7) = ", 0
	DBResult			db "Result DB(0-7) = ", 0

.code

start:

	invoke		crt_printf, offset ControllerInfo, 0
	
	invoke		crt_printf, offset DAPrompt, 0
	invoke		crt_scanf, offset scanf8String, offset DAInput
	
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
	invoke		crt_scanf, offset scanf8String, offset DBInput

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

	invoke		crt_printf, offset FPrompt, 0
	invoke		crt_scanf, offset scanf8String, offset FInput

	mov ebx, 0
	mov esi, offset FInput
	mov ecx, 8
F_loop_start:
	shl ebx, 1
	lodsb
	cmp al, 31h
	jne F_next
	inc ebx
F_next:
	loop F_loop_start
	mov Fbyte, bl

	invoke		crt_printf, offset CIPrompt, 0
	invoke		crt_scanf, offset scanf8String, offset CIInput

	mov esi, offset CIInput
	lodsb
	cmp al, 31h
	jne Start_compute
	mov CIbyte, 1


Start_compute:
	mov ebx, 0
	mov ecx, 0
	mov bl, DAbyte
	mov cl, DBbyte

	mov al, Fbyte
	bt ax, 7		; Test F0
	jnc End_compute
	
Test_F_1000:		; Test F=1000
	
	bt ax, 6		; F1=0
	jc Test_F_1001

	bt ax, 5		; F2=0
	jc Test_F_1001

	bt ax, 4		; F3=0
	jc Test_F_1001

	; Inversion B
	xor cl, 11111111b
	add cl, CIbyte
	mov DBbyte, cl
	jmp End_compute

Test_F_1001:		; Test F=1001
	
	bt ax, 6		; F1=0
	jc Test_F_1010

	bt ax, 5		; F2=0
	jc Test_F_1010

	bt ax, 4		; F3=1
	jnc Test_F_1010

	; Restriction by B
	xor cl, 11111111b
	and bl, cl
	mov DAbyte, bl
	mov DBbyte, cl

Test_F_1010:		; Test F=1010
	
	bt ax, 6		; F1=0
	jc Test_F_1011

	bt ax, 5		; F2=1
	jnc Test_F_1011

	bt ax, 4		; F3=0
	jc Test_F_1011

	; Sending A
	add bl, CIbyte
	mov DAbyte, bl

Test_F_1011:		; Test F=1011
	
	bt ax, 6		; F1=0
	jc Test_F_1100

	bt ax, 5		; F2=1
	jnc Test_F_1100

	bt ax, 4		; F3=1
	jnc Test_F_1100

	; Disjunction
	or bl, cl
	mov DAbyte, bl
	mov DBbyte, cl

Test_F_1100:		; Test F=1100
	
	bt ax, 6		; F1=1
	jnc Test_F_1101

	bt ax, 5		; F2=0
	jc Test_F_1101

	bt ax, 4		; F3=0
	jc Test_F_1101

	; Fields substraction
	sub bl, cl
	sub bl, 1
	add bl, CIbyte
	mov DAbyte, bl
	mov DBbyte, cl

Test_F_1101:		; Test F=1101
	
	bt ax, 6		; F1=1
	jnc Test_F_1110

	bt ax, 5		; F2=0
	jc Test_F_1110

	bt ax, 4		; F3=1
	jnc Test_F_1110

	; XOR
	xor bl, cl
	mov DAbyte, bl
	mov DBbyte, cl

Test_F_1110:		; Test F=1110
	
	bt ax, 6		; F1=1
	jnc Test_F_1111

	bt ax, 5		; F2=1
	jnc Test_F_1111

	bt ax, 4		; F3=0
	jc Test_F_1111

	; Sending B
	add cl, CIbyte
	mov DBbyte, cl

Test_F_1111:		; Test F=1111
	
	bt ax, 6		; F1=1
	jnc End_compute

	bt ax, 5		; F2=1
	jnc End_compute

	bt ax, 4		; F3=1
	jnc End_compute

	; Reverse fields substraction
	sub cl, bl
	sub cl, 1
	add cl, CIbyte
	mov DAbyte, bl
	mov DBbyte, cl

End_compute:

	mov bl, DAbyte
	mov esi, offset DAOutput
	add esi, 7
	mov ecx, 0
DA_loop_print:
	bt bx, 0
	jnc DA_loop_print_zero
	mov byte ptr [esi], 31h
DA_loop_print_zero:
	shr bx, 1
	dec esi
	inc ecx
	cmp ecx, 8
	jl DA_loop_print

	invoke		crt_printf, offset DAResult, 0
	invoke		crt_printf, offset DAOutput, 0
	
	mov bl, DBbyte
	mov esi, offset DBOutput
	add esi, 7
	mov ecx, 0
DB_loop_print:
	bt bx, 0
	jnc DB_loop_print_zero
	mov byte ptr [esi], 31h
DB_loop_print_zero:
	shr bx, 1
	dec esi
	inc ecx
	cmp ecx, 8
	jl DB_loop_print

	invoke		crt_printf, offset DBResult, 0
	invoke		crt_printf, offset DBOutput, 0

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