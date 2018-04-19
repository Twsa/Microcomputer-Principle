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
	ORG		001BH
	LJMP	INT1_CALL
	ORG		0030H
		
MAIN:	
		LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作	
		SJMP	$				;等待中断

INT0_CALL:	MOV		TL1,R6	
			MOV		TH1,R7
			CPL		BUZ	 
			
			MOV		TL0,#T01	
			MOV		TH0,#T02
			SETB	ET1			;开启T1中断
			CLR		TF1			
			RETI		
			
INT1_CALL:	CLR		ET1			;关闭T1中断	
			CPL		BUZ	
			RETI
;Initialization
INIT:	MOV		P1,#0FFH
		BUZ		EQU	P2.0
		LED		EQU	P1.0
		MOV		A,#00H	
		MOV		B,#00H
		MOV		R5,#00H
		MOV		SP,#0EFH		;设置堆栈指针
		MOV		R4,#1D			;设置占空比
		ACALL	DUTY_OPER
		RET
;Set duty ratio		设置占空比 并为 T0 T1赋初值
			;设置占空比 和 设置占空比对应的T1的初值
			;duty=10	0XFF9C
			;duty=20	0XFF38
			;duty=30	0XFED4
			;duty=40	0XFE70
			;duty=50	0XFE0C
			;duty=60	0XFDA8
			;duty=70	0XFD44
			;duty=80	0XFCE0
			;duty=90	0XFC7C
			;duty=100	0XFC18
			;T11		EQU	0E0H	
			;T12		EQU	0B1H
DUTY_OPER:
			;设置周期
			MOV		DPTR,#DUTY		;int duty table ptr
			T01		EQU	18H
			T02		EQU	0FCH
			
			;从列表中选择占空比对应的T1初值
			MOV		A,R4	
			MOV		B,#00H
			DEC		A
			RL		A
			MOV		B,A
			MOVC	A,@A+DPTR
			MOV		R7,A
			MOV		A,B
			ADD		A,#0X01	
			MOVC	A,@A+DPTR	
			MOV		R6,A
			
			RET
;Interrupt operation control
INT_OPER:	
			MOV		TMOD,#11H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02
			
			SETB	ET0			;允许T0中断	
			CLR		TF0			;清0标志位TF0
			ACALL	NVIC		;设置中断优先级
			SETB	EA			;CPU开中断
			SETB	TR1
			SETB	TR0	
			RET
			
;Set the priority of interrupt 	
NVIC:		CLR		PX0	
			CLR		PT0
			CLR		PX1				
			CLR		PT1
			CLR		PS
			RET			
DUTY:	DB 		0XFF,0X9C,0XFF,0X38,0XFE,0XD4,0XFE,0X70,0XFE,0X0C,\
				0XFD,0XA8,0XFD,0X44,0XFC,0XE0,0XFC,0X7C,0XFC,0X18
			END