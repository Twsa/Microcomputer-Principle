;Initialization
INIT:	
		LEDS	EQU	P1			
		TIME	EQU	100D		
		T01		EQU	0F0H	
		T02		EQU 0D8H		;计数值值的高位	定时10MS
		LEDFG	EQU	30H			;LED的标志
		T0_MUL	EQU	31H			;Timer 计数值的倍数
		T0MUL_TMP	EQU	32H		;Timer 计数值的倍数临时数据
		;INT0FG	EQU	20H			;外部中断0	flag
		;INT1FG	EQU	21H			;外部中断1	flag
		PT0FG	EQU	22H			;定时器0中断	flag
		;		CS1		EQU		
;		CS2		EQU		
		OE		EQU		P3.7
		WE		EQU		P3.6
			
		MOV		LEDS,#0FFH
		MOV		LEDFG,#0XFE
		;CLR		INT0FG				
		;CLR		INT1FG	
		CLR		PT0FG
		MOV		T0_MUL,#TIME
		MOV		T0MUL_TMP,#TIME
		MOV		A,#00H			
		MOV		SP,#0EFH		;设置堆栈指针
		RET
	
;Interrupt operation control
INT_OPER:	MOV		TMOD,#01H	;T0为方式1 定时器
			MOV		TL0,#T01	
			MOV		TH0,#T02	
			;SETB 	IT0			;设置外部中断0为下降沿触发
			;SETB 	IT1			;设置外部中断1为下降沿触发
			;SETB	EX0			;外部中断0开中断
			;SETB	EX1			;外部中断1开中断	
			SETB	ET0			;允许T0中断	
			;SETB	ET1			;允许T1中断
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