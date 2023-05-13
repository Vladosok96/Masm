; #########################################################################

	.486
	option casemap :none   ; case sensitive

; #########################################################################

	include			C:\masm32\include\masm32rt.inc

; #########################################################################

.data
	
	ControllerInfo		db "Контроллер КР1802ВС1", 10, 13,0
	inputAPrompt   		db "Enter DA0-7 >>>", 10, 13,0
	inputBPrompt		db "Enter DB0-7 >>>", 10, 13,0

	printString			db "%s ", 0
	scanInteger			db "%d", 0
	printInteger   		db "%d ", 0
	printFloat			db "%f ", 0
	printNormal   		db "%de%d ", 0

	inputA				db 0
	inputB				db 0

.code

start:

	invoke		crt_printf, offset ControllerInfo, 0	
	
	invoke		crt_printf, offset ControllerInfo, 0	
	invoke		crt_scanf, offset scanInteger, offset firstNumber
	
	invoke		crt_printf, offset ControllerInfo, 0	
	invoke		crt_scanf, offset scanInteger, offset firstNumber


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