; FileName		:		lab2.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-10
; Description	:		This is a lab ofm AT89C52RC.
;						The lab achieve function that include binkeying
;						,delay,light leds and switch using
 
;Main function
	ORG		0000H
	LJMP	MAIN
	ORG		0003H
	LJMP	INT0_CALL
	ORG		0013H
	LJMP	INT1_CALL
	
	ORG		0030H
MAIN:	LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作
		LCALL	BLINK			;流水灯操作			
INT0_CALL:	CPL	20H
			RETI
INT1_CALL:	CPL	21H
			RETI
;Initialization
INIT:	MOV		P1,#0FFH
		MOV		A,#00H			
		MOV		30H,#0XFE
		CLR		20H				;清除外部中断0	flag
		CLR		21H				;清除外部中断1	flag
		MOV		SP,#0EFH		;设置堆栈指针
		RET
;Interrupt operation control
INT_OPER:	SETB 	IT0				;设置外部中断0为下降沿触发
			SETB 	IT1				;设置外部中断1为下降沿触发
			SETB	EX0				;外部中断0开中断
			SETB	EX1				;外部中断1开中断
			ACALL	NVIC			;设置中断优先级
			SETB	EA				;CPU开中断
			RET
			
;Set the priority of interrupt 	
NVIC:		CLR		PX0				;设置外部中断0为低优先级
			CLR		PT0
			SETB	PX1				;设置外部中断1为高优先级
			CLR		PT1
			CLR		PS
			RET
BLINK:	MOV		A,30H
		MOV 	P1,A
		JB		21H,STOP
		JB		20H,PAUSE
		RL		A
		MOV		30H,A	
		LCALL 	DELAY
		CJNE	A,#0XFE,NEXT
		MOV		30H,#0XFE	
NEXT:	SJMP	BLINK
STOP:	MOV		P1,#0XFF
		JB		21H,STOP
		MOV		30H,#0XFE
		SJMP	BLINK
PAUSE:	MOV		P1,A
		JB		21H,STOP
		JB		20H,PAUSE
		SJMP	BLINK
		
;Delay function
DELAY:	MOV  	R7,#3
DEL1:	MOV		R6,#200
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
		END
	
