; #########################################################################

    .486
    ;.model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    ;include		C:\masm32\include\user32.inc
	;includelib	C:\masm32\lib\user32.lib
	;include		C:\masm32\include\kernel32.inc
	;includelib	C:\masm32\lib\kernel32.lib

	;include		C:\masm32\include\msvcrt.inc
	;includelib	C:\masm32\lib\msvcrt.lib

	include		C:\masm32\include\masm32rt.inc

; #########################################################################

	.data
	
    inputStringPrompt   db "Enter numbers (d...d.f...f) >>>", 0
    inputIPrompt   		db "Enter I>>>", 0
    inputJPrompt		db "Enter J>>>", 0
	selectedWords   	db "Selected numbers: ", 0

	trueString			db 10, 13, "True ", 0
	falseString			db 10, 13, "False ", 0

    scanLine    		db "%[^", 10,"]", 0
	printString			db "%s ", 0
    scanInteger    		db "%d", 0
    printInteger   		db "%d ", 0
	printFloat    		db "%f ", 0
	printNormal   		db "%de%d, ", 0

	tmpFloat			dq 0.0
	tmpInteger			dd 0
    searchCounter		dd 0
    indexCounter		dd 0
    firstNumber			dd 0
    secondNumber		dd 0

	tenNumber			dq 10.0

	charactrNumber		dd 0
	IFloat				dq 0.0
	JFloat				dq 0.0

	.data?
	;tmpString      		db 256 dup(?)
    inputString      	db 256 dup(?)
	indexArray      	dw 256 dup(?)

    .code

start:

    invoke      crt_printf,offset inputStringPrompt, 0
	invoke      crt_scanf, offset scanLine, offset inputString	
	
	invoke      crt_printf,offset inputIPrompt, 0
	invoke      crt_scanf, offset scanInteger, offset firstNumber
    ;invoke      crt_printf,offset printInteger, firstNumber
	
	invoke      crt_printf,offset inputJPrompt, 0
    invoke      crt_scanf, offset scanInteger, offset secondNumber
    ;invoke      crt_printf,offset printInteger, secondNumber

	mov edx, 0
	mov ebx, 0
    jmp search_start

search_cycle:
	inc searchCounter
	cmp searchCounter, 255
	jge print_selected
search_start:	
    mov eax, offset inputString
    add eax, searchCounter
	mov bl, [eax]

    cmp dl, 0
    je search_word
    jne search_end_word

search_word:
	cmp bl, ' '
	je search_word_set_zero
	mov eax, offset indexArray
	add eax, indexCounter
	mov ecx, 0
	mov ecx, searchCounter
	mov dword ptr [eax], ecx
	inc indexCounter
	mov dl, 1
	jmp search_cycle
search_word_set_zero:
	mov byte ptr [eax], 0
	jmp search_cycle

search_end_word:
	cmp bl, ' '
	jne search_cycle
	mov dl, 0
	jmp search_word_set_zero


print_selected:
	invoke      crt_printf, offset selectedWords, 0
	
	mov eax, offset indexArray
	add eax, firstNumber
	dec eax
	mov bl, [eax]
	mov eax, offset inputString
	add eax, ebx

	invoke  StrToFloat, eax, ADDR tmpFloat

start_convertion_I:
	fld1
	fld tmpFloat
	fst IFloat
	fprem
	fldz
	fcomi st,st(1)

	je equals_zero_I
	
	inc charactrNumber
	fld tenNumber
	fld tmpFloat
	fmul
	fstp tmpFloat
	fstp st(0)
	fstp st(0)
	fstp st(0)

	jmp start_convertion_I
	
equals_zero_I:

	fld tmpFloat
	fistp tmpInteger

	invoke      crt_printf,offset printNormal,tmpInteger, charactrNumber
	
	mov eax, offset indexArray
	add eax, secondNumber
	dec eax
	mov bl, [eax]
	mov eax, offset inputString
	add eax, ebx

	invoke  StrToFloat, eax, ADDR tmpFloat

start_convertion_J:
	fld1
	fld tmpFloat
	fst IFloat
	fprem
	fldz
	fcomi st,st(1)

	je equals_zero_J
	
	inc charactrNumber
	fld tenNumber
	fld tmpFloat
	fmul
	fstp tmpFloat
	fstp st(0)
	fstp st(0)
	fstp st(0)

	jmp start_convertion_J
	
equals_zero_J:
	fld tmpFloat
	fistp tmpInteger

	invoke      crt_printf,offset printNormal,tmpInteger, charactrNumber

	;mov ebx, 0
	;mov eax, offset indexArray
	;add eax, indexCounter
	;mov bl, [eax]
	;mov eax, offset inputString
	;add eax, ebx
	;invoke      crt_printf,offset printInteger, ebx

	;inc indexCounter
	;cmp indexCounter, 16
	;jne print_iteration


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