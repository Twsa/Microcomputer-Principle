; FileName		:	exc5.ASM	
; Author		:	Twsa Liu
; Date			:	2018-04-03
; Description	:	This is delay demo,which including two different
;					models,each contains command "NOP",and the other no

;Init	
		ORG		0000H
		MOV		R6,#0X00		;x
		MOV		R7,#0X00		;y
		MOV		A,#0X00			
;Main
MAIN:	CPL 	A
		MOV		P1,A
		LCALL	TG2
		AJMP	MAIN
;Delay with command NOP
;2*x*y+(1+1+2)*y=69*1000 (osc=12M)
;set x=0xff then y=0x42
TG1:	MOV		R6,#0XFF		;x
		MOV		R7,#0X42		;y
DEL1:	DJNZ	R6,$			;2
DEL2:	NOP						;1
		MOV		R6,#0XFF		;1
		DJNZ	R7,DEL1			;2
		RET

;Delay randomly
;2*x*y+(1+2)*y=69*1000 (osc=12M)
;set x=0xff then y=0x43
TG2:
		MOV		R6,#0XFF		;x
		MOV		R7,#0X43		;y
DEL3:	DJNZ	R6,$			;2
DEL4:	MOV		R6,#0XFF		;1
		DJNZ	R7,DEL1			;2
		RET
		END