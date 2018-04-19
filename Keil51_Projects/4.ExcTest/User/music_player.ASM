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
		LCALL	SELECT
		SJMP	$				;等待中断

INT0_CALL:	MOV		TL1,R2	
			MOV		TH1,R3
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
		MOV		P2,#0FFH
		BUZ		EQU	P2.0
		LED		EQU	P1.0
		MOV		A,#00H	
		MOV		B,#00H
		MOV		R5,#00H
		MOV		SP,#0EFH		;设置堆栈指针
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
			MOV		R3,A
			MOV		A,B
			ADD		A,#0X01	
			MOVC	A,@A+DPTR	
			MOV		R2,A
			
			RET
;Interrupt operation control
INT_OPER:	
			MOV		TMOD,#11H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02
			
			;SETB	ET0			;允许T0中断	
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
;Select the song you like to play
SELECT:		
WAIT0:		JB		P1.1,WAIT1
			ACALL	PLAYER1
WAIT1:		JB		P1.2,WAIT0
			ACALL	PLAYER2
			RET
;Play music you have selected
PLAYER1:	MOV		A,#00H
			MOV		R0,#00H
			MOV		DPTR,#MUSIC1		;music1 table ptr
			
MU1:		MOVC	A,@A+DPTR
			SETB	ET0	
			MOV		R4,A			;设置占空比
			LCALL	DUTY_OPER
			ACALL	DELAY			;BUZ time delay
			ACALL	PAUSE	
			INC		R0
			MOV		A,R0
			CJNE	A,#0X1C,MU1
WAIT00:		JNB		P1.1,PLAYER1
			CLR		ET0
			SETB	BUZ
			AJMP	SELECT
;Play music you have selected
PLAYER2:	SETB	ET0
			MOV		R4,#5D			;设置占空比	
			LCALL	DUTY_OPER
WAIT10:		JNB		P1.2,WAIT10
			CLR		ET0
			SETB	BUZ
			AJMP	SELECT	
PAUSE:		SETB	BUZ
			CLR		ET0
			ACALL	DELAY1	
			RET
;Delay Function 1s delay
DELAY:	MOV  	R7,#4
DEL1:	MOV		R6,#200 	
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
;Delay Function PAUSE
DELAY1:	MOV  	R7,#4
DEL11:	MOV		R6,#200 	
DEL21:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL21
		DJNZ	R7,DEL11
		RET
DUTY:	DB 		0XFF,0X9C,0XFF,0X38,0XFE,0XD4,0XFE,0X70,0XFE,0X0C,\
				0XFD,0XA8,0XFD,0X44,0XFC,0XE0,0XFC,0X7C,0XFC,0X18
MUSIC1:	DB 		0X01,0X01,0X05,0X05,0X06,0X06,0X05,\
				0X04,0X04,0X03,0X03,0X02,0X02,0X01,\
				0X05,0X05,0X04,0X04,0X03,0X03,0X02,\
				0X05,0X05,0X04,0X04,0X03,0X03,0X02
			END