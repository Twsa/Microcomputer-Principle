; FileName		:	7seg.ASM	
; Author		:	Twsa Liu
; Date			:	2017-03-20
; Description		:	Lab1  I/O Control Test

;MAIN
		ORG		0000H
INIT:	MOV 	P2,#0FFH
	MOV	P1,#0FFH
SYSTEM_WAIT:	JNB	P3.0,SYSTEM_WAIT

LOOP:   	MOV     P1,P2 
		JNB	P3.0,SYSTEM_WAIT					
		AJMP	LOOP		

;Delay Function 1s delay
DELAY:	MOV  	R7,#10
DEL1:	MOV		R6,#200
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
		END
		