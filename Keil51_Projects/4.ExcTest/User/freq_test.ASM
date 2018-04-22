; FileName		:		lab3.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-20
; Description	:		This is a lab of AT89C52RC.
 
;Main function
	ORG		0000H
	LJMP	MAIN
	
	;ORG		0003H
	;LJMP	INT0_CALL
	;ORG		0013H
	;LJMP	INT1_CALL
	ORG		000BH
	LJMP	PT0_CALL
	ORG		001BH
	LJMP	PT1_CALL
	
		ORG		0030H
MAIN:	LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作	
		SJMP	$				;等待中断
			
PT0_CALL:	MOV		TH0,30H
			MOV		TL0,31H	
			CPL		BUZ
			RETI

PT1_CALL:	MOV		TH1,#3CH
			MOV		TL1,#0B0H	
			DJNZ	R7,RT
			MOV		R7,#20D
			CPL		P1.4
			LCALL	FreTest	
RT:			RETI
;Initialization
INIT:	MOV		DPTR,#MUSIC1		;music1 table ptr
		BUZ		EQU	P2.0
		MOV		P1,#0FFH
		MOV		30H,#0Xfc		
		MOV		31H,#0x8f		;保存节拍的地址
		MOV		32H,#0x00		
		MOV		SP,#0EFH		;设置堆栈指针
		MOV		TH0,#30H
		MOV		TL0,#30H	
		MOV		TH1,#3CH
		MOV		TL1,#0B0H	
		MOV		R7,#20D
		MOV		A,#00H
		MOV		B,#00H
		RET
;Interrupt operation control
INT_OPER:	MOV		TMOD,#11H	;T0为方式1 定时器
			;SETB 	IT0			;设置外部中断0为下降沿触发
			;SETB 	IT1			;设置外部中断1为下降沿触发
			;SETB	EX0			;外部中断0开中断
			;SETB	EX1			;外部中断1开中断	
			SETB	ET0			;允许T0中断	
			SETB	ET1			;允许T0中断
			CLR		TF0			;清0标志位TF0
			CLR		TF1			;清0标志位TF1
			ACALL	NVIC		;设置中断优先级
			SETB	EA			;CPU开中断
			SETB	TR0	
			SETB	TR1
			RET
			
;Set the priority of interrupt 	
NVIC:		CLR		PX0	
			CLR		PT0
			CLR		PX1				
			CLR		PT1
			CLR		PS
			RET		
;Select the song you like to play		
FreTest:	MOV		A,32H
			INC		A
			MOV		32H,A
			ACALL	Frequ
			MOV		A,32H
			CJNE	A,#8D,RT1
			MOV		32H,#1D
RT1:		RET
;设置载频率
Frequ:		
			;从列表中选择占空比对应的T1初值
			MOV		A,32H	
			MOV		B,#00H
			DEC		A
			RL		A
			MOV		B,A
			MOVC	A,@A+DPTR
			MOV		30H,A
			MOV		A,B
			ADD		A,#0X01	
			MOVC	A,@A+DPTR	
			MOV		31H,A	
			RET			
MUSIC1:	DB 	0Xfc,0x8f,0Xfc,0xef,0Xfd,0x45,0Xfd,0x6c,0Xfd,0xb5,0Xfd,0xf5,0Xfe,0x2e

			;0Xfe48,0Xfe78,0Xfea3,0Xfeb7,0Xfedb,0Xfefb,0Xff17,
		END