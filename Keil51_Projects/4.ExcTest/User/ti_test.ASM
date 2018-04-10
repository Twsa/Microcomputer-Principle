; FileName		:	it_test.ASM	
; Author		:	Twsa Liu
; Date			:	2018-04-03
; Description	:   The skeleton of interrupt programming

;主程序
;1.主程序的起始地址
;2.主程序的中断初始化
;	(1)设置堆栈指针SP
;	(2)CPU开中断
;	(3)允许响应中断源中断
;	(4)设置中断的优先级
;	(5)若是外部中断源，设置中断请求的触发方式IT0或IT1，
;	   以决定是下降沿还是低电平触发方式

;中断服务程序
;1.中断服务程序的起始地址
;2.中断服务程序
;	(1)保护和恢复现场
;	(2)关中断和开中断
;	(3)中断返回

	ORG		0000H
	LJMP	MAIN
	ORG		0003H
	LJMP	INT
	ORG		0030H
MAIN:	ORL		P1,#0FFH
		MOV		SP,#0EFH	;设置堆栈指针
		MOV		R0,#7FH		;设置P1口输出初值，使其循环左移1位后即点亮L0
		SETB 	IT0			;设置外部中断0为下降沿触发
		SETB	EX0			;外部中断0开中断
		SETB	EA			;CPU开中断
HERE:	AJMP	HERE		;等待中断
INT:	PUSH	PSW			;保护现场
		PUSH	ACC			
		MOV		A,R0
		RL		A
		MOV		R0,A
		MOV		P1,A		;一个发光二极管亮
		POP		ACC
		POP		PSW			;恢复现场
		RETI				
		END
		