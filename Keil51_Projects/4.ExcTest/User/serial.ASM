; FileName		:	serial.ASM	
; Author		:	Twsa Liu
; Date			:	2018-04-16
; Description	:   Serial test

;题目：用AT89C52RCD单片机的串行接口扩展一个8位并行输出口，接8个发光二极管，
;	   编写发数码管从0-F的程序

	ORG		0000H
	LJMP	MAIN
	ORG		0023H	;串行中断的入口地址
	LJMP	SINT	;转向串行接口中断服务程序
	ORG		0100H
		
MAIN:	MOV		SP,#0EFH
		MOV		A,#80H
		MOV		B,#00H
		MOV		DPTR,#LED_Y    ;初始化指针
		MOV		SCON,#00H		;串行接口方式0
		SETB	ES				;允许串行接口中断
		SETB	EA				;
		SETB	P1.0			;CLR=1,打开并行输出端
		MOV		SBUF,A
		SJMP	$
SINT:	ACALL	GETSEG
		ACALL	DELAY
		CLR		TI			;清除发送中断位
		MOV		SBUF,A
		RETI
GETSEG:		MOV		R7,#00H
			MOV		A,B
			MOVC	A,@A+DPTR
			MOV		R7,A
			INC		B
			MOV		A,B
			CJNE  	A,#10,NEXT
			MOV		B,#0
NEXT:		MOV		A,R7		
			RET
;Delay function
DELAY:	MOV  	R7,#3
DEL1:	MOV		R6,#200
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
		
LED_Y:  DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H
		END

