; FileName		:		lab4.ASM	
; Author		:		Twsa Liu
; Date			:		2018-04-26
; Description	:		This is a lab of AT89C52RC.
;						The lab achieve function extending RAM and ROM
 
 

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
	RUNFG	EQU	P3.2
		
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
;Main function		
MAIN:	LCALL	INIT
		LCALL	INT_OPER
		LCALL	EX_RAM_INIT
START:	LCALL	READING
		SJMP	START

;timer0 interrupt call 
PT0_CALL:	MOV		TL0,#T01	
			MOV		TH0,#T02			;重载计数值
			DJNZ	T0MUL_TMP,R_T0TI	
			;do something in timer0 interrupt
			SETB	PT0FG
			MOV		T0MUL_TMP,T0_MUL
R_T0TI:		RETI

;external interrupt 0 call STOP
INT0_CALL:	CPL		INT0FG
			JB		INT0FG,RETI_INT0  		;判断系统是否启动，启动则停止
			CLR		TR0
			POP		ACC						;将PC值提前出栈
			POP		ACC
			MOV		A,#0X3C					;将入栈所保护的PC值修改为0X003C进行停止操作
			PUSH	ACC
			MOV		A,#0X00
			PUSH	ACC
			RETI		
RETI_INT0:	SETB  	TR0						;系统没启动则启动
			RETI
;external interrupt 1  call	PAUSE
INT1_CALL:	JNB		INT0FG,R_INT1TI			;判断是否启动
			CPL		INT1FG
			CPL		TR0	
R_INT1TI:	RETI	

;Initialization
INIT:	MOV		LEDS,#0FFH
		CLR		INT0FG				
		CLR		INT1FG	
		CLR		PT0FG
		MOV		T0_MUL,#TIME
		MOV		T0MUL_TMP,#TIME		
		MOV		SP,#0EFH		;设置堆栈指针
		RET
;Interrupt operation control
INT_OPER:	MOV		TMOD,#01H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02	
			SETB 	IT0			;设置外部中断0为下降沿触发
			SETB 	IT1			;设置外部中断1为下降沿触发
			SETB	EX0			;外部中断0开中断
			SETB	EX1			;外部中断1开中断	
			SETB	ET0			;允许T0中断	
			SETB	ET1			;允许T1中断
			CLR		TF0			;清0标志位TF0
			CLR		TF1			;清0标志位TF1
			ACALL	NVIC		;设置中断优先级
			SETB	EA			;CPU开中断
			CLR		TR0			;暂时不启动定时器0	
			;SETB	TR1
			RET	
;Set the priority of interrupt 	
NVIC:		SETB	PX0	
			CLR		PT0
			SETB	PX1				
			CLR		PT1
			CLR		PS
			RET		
;writing something to external RAM
EX_RAM_INIT:	MOV		A,#00H
				MOV		P2,#00H
				MOV		R0,#00H
WRITE8:			MOVX	@R0,A
				INC		R0
				INC		A
				CJNE	A,#0X08,WRITE8
				RET
;reading someghing to LEDS
READING:	MOV		A,#00H
			MOV		DPTR,#0000H
			MOV		LEDFG,#0X08
			MOV		LEDS,#0FFH
READ8:		JNB		PT0FG,READ8			;判断定时时间有没有到
			CLR		PT0FG
			MOVX	A,@DPTR
			ADD		A,#0X11				;将读到的数据加上0X11
			MOV		LEDS,A
			INC		DPTR
			DJNZ	LEDFG,READ8
			MOV		LEDFG,#0X08
			RET		
			END