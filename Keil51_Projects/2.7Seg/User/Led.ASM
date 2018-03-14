;
; Author		:	Twsa Liu
; Date			:	2017-03-14
; Description	:	学习使用数码管 

;MAIN
LOOP: 
SETB 	P1.0		;(1)(熄灭灯)
LCALL 	DELAY		;(2)延长一段时间
CLR 	P1.0		;(3)点亮灯
LCALL 	DELAY		;(2)延长一段时间
AJMP	LOOP		;(5)跳转到第一句LOOP处

;Sub Function
DELAY:
MOV 	R7,#250		
D1:
MOV 	R6,#250	
D2:		
DJNZ	 R6,D2
	DJNZ 	R7,D1
	RET				;子程序返回，回到调用处
END
	