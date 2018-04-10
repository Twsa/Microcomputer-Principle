; FileName		:	exc6.ASM	
; Author		:	Twsa Liu
; Date			:	2018-04-08
; Description	:   The skeleton of interrupt programming with timer

;题目：利用定时器中断技术，在P1.0口输出脉冲周期为 2*（50+19)=138ms 的方波。
;要求： 
   ;1）晶振频率自行设定；
   ;2）有详细的初值计算过程；
   ;3）绘制主程序流程图、中断服务子程序流程图；
   ;4）比较采用软件延时与定时器中断定时的设计过程，设计结果。
   ;5）形式：word 文档
   ;6）截止时间：5月1日

;(1)选择工作方式
;	选择方式1 定时器 定时1ms
;(2)计算T1初值
;	T0初值=2^16-1000*f/12=65536-1000*12/12=65534=FC17H
;(3)源程序
		ORG		0000H
		LJMP	MAIN
		ORG		000BH	;T0中断入口地址 
		LJMP	PT0F	
		ORG		0030H	;主程序的入口地址
MAIN:	MOV		SP,#0EFH	;堆栈设在0F0H~0FFH (内部数据存储区)
		MOV		R7,#69D
		MOV		TMOD,#01H	;T0为方式1 定时器
		MOV		TL0,#17H	
		MOV		TH0,#0FCH
		SETB	ET0			;允许T0中断	
		CLR		F0			;清0标志位F0
		SETB	EA			;CPU开中断
		SETB	TR0			;启动T0
HERE:	SJMP	HERE		;等待T0中断
PT0F:	MOV		TL0,#17H	
		MOV		TH0,#0FCH
		DJNZ	R7,RT
		MOV		R7,#69D
		CPL		P1.0
RT:		RETI	
		END

;方式1 操作TIM0	 查询方式程序
		;ORG		0000H
		;LJMP	MAIN	
		;ORG		0030H
;MAIN:	MOV		SP,#0EFH
		;MOV		TMOD,#01H
		;MOV		TL0,#78H
		;SETB	TR0
;LOOP:	JBC		TF0,NEXT
		;SJMP	LOOP
;NEXT:	MOV		TH0,#0ECH
		;MOV		TL0,#78H
		;CPL		P1.0
		;SJMP 	LOOP
		;END
;方式2 操作TIM0	 溢出中断的方式程序
		;ORG		0000H
		;LJMP	MAIN
		;ORG		000BH	;T0中断入口地址 
		;LJMP	PT0F	
		;ORG		0030H	;主程序的入口地址
;MAIN:	MOV		SP,#0EFH	;堆栈设在0F0H~0FFH (内部数据存储区)
		;MOV		TMOD,#02H	;T0为方式2 定时器
		;MOV		TL0,#00H	
		;MOV		TH0,#00H
		;SETB	ET0			;允许T0中断	
		;CLR		F0			;清0标志位F0
		;SETB	EA			;CPU开中断
		;SETB	TR0			;启动T0
;HERE:	SJMP	HERE		;等待T0中断
;PT0F:	CPL		P1.0		;输出方波
		;RETI
		;END
