; FileName		:		lab3.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-20
; Description	:		This is a lab of AT89C52RC.
 
;Main function
	ORG		0000H
	LJMP	MAIN
	
	ORG		0003H
	LJMP	INT0_CALL
	ORG		0013H
	LJMP	INT1_CALL
	ORG		000BH
	LJMP	PT0_CALL
	;ORG		001BH
	;LJMP	PT1_CALL
	ORG		0030H
MAIN:	LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作
		LCALL	BLINK		
		SJMP	$				;等待中断
			
PT0_CALL:	MOV		TL0,#T01	
			MOV		TH0,#T02			;重载计数值，10MS定时时间
			DJNZ	T0MUL_TMP,R_T0TI	
			;do something in timer0 interrupt
			CPL		P2.7
			SETB	PT0FG
			MOV		T0MUL_TMP,T0_MUL
R_T0TI:		RETI
INT0_CALL:	;CPL		INT0FG
			LCALL	TIM_Div2
			RETI
INT1_CALL:	CPL		INT1FG
			RETI			
;Initialization
INIT:	
		LEDS	EQU	P1			
		TIME	EQU	100D		
		T01		EQU	0F0H	
		T02		EQU 0D8H		;计数值值的高位	定时10MS
		LEDFG	EQU	30H			;LED的标志
		T0_MUL	EQU	31H			;Timer 计数值的倍数
		T0MUL_TMP	EQU	32H		;Timer 计数值的倍数临时数据
		INT0FG	EQU	20H			;外部中断0	flag
		INT1FG	EQU	21H			;外部中断1	flag
		PT0FG	EQU	22H			;定时器0中断	flag
			
		MOV		LEDS,#0FFH
		MOV		LEDFG,#0XFE
		CLR		INT0FG				
		CLR		INT1FG	
		CLR		PT0FG
		MOV		T0_MUL,#TIME
		MOV		T0MUL_TMP,#TIME
		MOV		A,#00H			
		MOV		SP,#0EFH		;设置堆栈指针
		RET
;Interrupt operation control
INT_OPER:	MOV		TMOD,#11H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02	
			SETB 	IT0			;设置外部中断0为下降沿触发
			SETB 	IT1			;设置外部中断1为下降沿触发
			SETB	EX0			;外部中断0开中断
			SETB	EX1			;外部中断1开中断	
			SETB	ET0			;允许T0中断	
			SETB	ET1			;允许T1中断
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
			SETB	PX1				
			CLR		PT1
			CLR		PS
			RET
			
;Blinky leds operations which includes stopping and pausing function
BLINK:	JNB		PT0FG,BLINK      ;等待timer0定时器中断的到来
		CLR		PT0FG			 ;清除timer0中断标志位
		MOV		A,LEDFG
		MOV 	LEDS,A
		JB		INT1FG,STOP
		JB		INT0FG,PAUSE
		RL		A
		MOV		LEDFG,A	
		;LCALL 	DELAY
		CJNE	A,#0XFE,NEXT
		MOV		LEDFG,#0XFE	
NEXT:	SJMP	BLINK

;The stop and pause
STOP:	MOV		LEDS,#0XFF
		JB		INT1FG,STOP
		MOV		LEDFG,#0XFE
		SJMP	BLINK
PAUSE:	MOV		LEDS,A
		JB		INT1FG,STOP
		JB		INT0FG,PAUSE
		SJMP	BLINK

TIM_Div2:	MOV		A,T0_MUL
			RR		A
			ANL		A,#0X7F
			MOV		T0_MUL,A
			RET
		END