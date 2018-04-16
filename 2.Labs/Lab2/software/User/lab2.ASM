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
MAIN:	
		LCALL	INIT			;初始化操作
		LCALL	INT_OPER		;中断的设置的相关操作	
		SJMP	$				;等待中断
			
INT0_CALL:	LCALL	TEST2
			RETI
INT1_CALL:	LCALL 	TEST1
			RETI
;Initialization
INIT:	MOV		P1,#0FFH
		MOV		A,#00H			
		MOV		B,#00H	
		MOV		DPTR,#LED_TB	;int led table ptr
		MOV		R0,#7FH			;设置P1口输出初值，使其循环左移1位后即点亮L0
		MOV		SP,#0EFH		;设置堆栈指针
		MOV		R4,#0FFH			;记录当前LED的状态
		RET
;Interrupt operation control
INT_OPER:	SETB 	IT0				;设置外部中断0为下降沿触发
			CLR 	IT1				;设置外部中断1为下降沿触发
			SETB	EX0				;外部中断0开中断
			SETB	EX1				;外部中断1开中断
			ACALL	NVIC			;设置中断优先级
			SETB	EA				;CPU开中断
			RET
			
;Set the priority of interrupt 	
NVIC:		SETB	PX0				;设置外部中断0为低优先级
			SETB	PX1				;设置外部中断1为高优先级
			CLR		PS
			CLR		PT1
			CLR		PT0
			RET
			
;Binkly and contain operation of stopping
WAIT1:	JB		P3.3,WAIT1
TEST1:	JB		P3.3,WAIT1
AGAIN1:	MOVC	A,@A+DPTR
		MOV		R4,A
		MOV 	P1,A
		JB		P3.3,STOP
		LCALL 	DELAY
		MOV		A,B
		INC		B
		CJNE	A,#0X07,NEXT1
		MOV		B,#0X00		;rest accumator A to zero
		RET
NEXT1:	SJMP	AGAIN1
STOP:	MOV		A,#00H
		MOV		B,#00H
		MOV		P1,#0XFF
		JB		P3.3,STOP
		SJMP	TEST1

;Binkly and contain operation of pasuing
WAIT2:	JB		P3.2,WAIT2
TEST2:	JB		P3.2,WAIT2
AGAIN2:	MOVC	A,@A+DPTR
PASUE:	MOV 	P1,A			;PASUE operator
		JB		P3.2,PASUE
		LCALL 	DELAY
		MOV		A,B
		INC		B
		CJNE	A,#0X07,NEXT2
		MOV		B,#0X00		;rest accumator A to zero
		RET
NEXT2:	SJMP	AGAIN2

;Delay function
DELAY:	MOV  	R7,#3
DEL1:	MOV		R6,#200
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
		
LED_TB:	DB 		0XFE,0XFD,0XFB,0XF7,0XEF,0XDF,0XBF,0X7F
		END
	
