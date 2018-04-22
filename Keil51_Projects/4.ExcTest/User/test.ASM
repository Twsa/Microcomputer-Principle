; FileName		:		lab2.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-10
; Description	:		This is a lab ofm AT89C52RC.
;						The lab achieve function that include binkeying
;						,delay,light leds and switch using
 
;Main function
	ORG		0000H
	LJMP	MAIN
	;ORG		0003H
	;LJMP	INT0_CALL
	;ORG		0013H
	;LJMP	INT1_CALL
	;ORG		0030H
	ORG		000BH
	LJMP	INT0_CALL
	;ORG		001BH
	;LJMP	INT1_CALL
	ORG		0030H
		
MAIN:	
		LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作
		SJMP	$				;等待中断

INT0_CALL:	CPL		BUZ	 		
			MOV		TL0,#T01	
			MOV		TH0,#T02		
			RETI		

;Initialization
INIT:	MOV		P1,#0FFH
		MOV		P2,#0FFH
		BUZ		EQU	P2.0
		LED		EQU	P1.0
		SW1		EQU	P1.1
		T01		EQU	18H
		T02		EQU	0FCH
		MOV		A,#00H	
		MOV		B,#00H
		MOV		SP,#0EFH		;设置堆栈指针
		RET
;Interrupt operation control
INT_OPER:	
			MOV		TMOD,#01H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02
			
			SETB	ET0			;允许T0中断	
			CLR		TF0			;清0标志位TF0
			ACALL	NVIC		;设置中断优先级
			SETB	EA			;CPU开中断
			SETB	TR0	
			RET
			
;Set the priority of interrupt 	
NVIC:		CLR		PX0	
			CLR		PT0
			CLR		PX1				
			CLR		PT1
			CLR		PS
			RET			
			END