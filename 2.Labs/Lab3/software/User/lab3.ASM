; FileName		:		lab3.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-20
; Description	:		This is a lab of AT89C52RC.
 
;Main function
	ORG		0000H
	LJMP	MAIN
	
	ORG		0003H
	LJMP	INT0_CALL
	;ORG		0013H
	;LJMP	INT1_CALL
	ORG		000BH
	LJMP	PT0_CALL
	;ORG		001BH
	;LJMP	PT1_CALL
	
	ORG		0030H
MAIN:	LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作	
		SJMP	$				;等待中断
			
PT0_CALL:	JB		P3.2,NEXT
			SJMP	NEXT1
NEXT:		MOV		R4,#TIME
NEXT1:		LCALL	BINK
			RETI
INT0_CALL:	LCALL	RATIODUBLE
			RETI
			
BINK:		MOV		TL0,#T01	
			MOV		TH0,#T02			;10MS定时时间
			DJNZ	R7,RT				
			MOV		30H,R4				
			MOV		R7,30H				;动态设置翻转时间
			MOV 	P1,R3
			CPL		P2.7
			MOV		A,R3
			RL		A
			MOV		R3,A
			CJNE	A,#0XFE,RT
			MOV		R3,#0XFE
RT:			RET
RATIODUBLE:	MOV		A,#TIME
			MOV		B,#2D
			DIV		AB
			MOV		R4,A		;时间限制减半，速度提升一倍
			RET
;Initialization
INIT:	
		TIME	EQU	100D
		T01		EQU	0F0H
		T02		EQU 0D8H
		MOV		P1,#0FFH

		MOV		A,#00H	
		MOV		B,#00H
		MOV		R7,#00H
		MOV		R4,#00H
		MOV		R3,#0FEH
		MOV		SP,#0EFH		;设置堆栈指针
		RET
;Interrupt operation control
INT_OPER:	MOV		TMOD,#01H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02	;10MS
			SETB 	IT0			;设置外部中断0为下降沿触发
			;SETB 	IT1			;设置外部中断1为下降沿触发
			SETB	EX0			;外部中断0开中断
			;SETB	EX1			;外部中断1开中断	
			SETB	ET0			;允许T0中断	
			CLR		TF0			;清0标志位TF0
			;CLR		TF1			;清0标志位TF1
			ACALL	NVIC		;设置中断优先级
			SETB	EA			;CPU开中断
			SETB	TR0	
			;SETB	TR1
			RET
			
;Set the priority of interrupt 	
NVIC:		CLR		PX0	
			CLR		PT0
			CLR		PX1				
			CLR		PT1
			CLR		PS
			RET		
			END
	
