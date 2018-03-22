; FileName		:	7seg.ASM	
; Author		:	Twsa Liu
; Date			:	2017-03-14
; Description	:	结合Keil与Proteus学习使用数码管 

;MAIN
		ORG		0000H
INIT:	MOV 	P1,#0XF0    ;(1)熄灭数码管
LOOP: 	LCALL   SEGBINKEY   ;(2)数码管的操作				
		AJMP	LOOP		;(3)跳转到第一句LOOP处

;Binkey 7Seg Function
SEGBINKEY:	       
			MOV  	P1,#0X81
			LCALL 	DELAY
			MOV  	P1,#0XF9
			LCALL 	DELAY
			MOV  	P1,#0X92
			LCALL 	DELAY
			MOV  	P1,#0XB0
			LCALL 	DELAY
			MOV  	P1,#0XE8
			LCALL 	DELAY
		    MOV  	P1,#0XA4
			LCALL 	DELAY
			MOV  	P1,#0X84
			LCALL 	DELAY
			MOV  	P1,#0XF1
			LCALL 	DELAY
			MOV  	P1,#0X80
			LCALL 	DELAY
			MOV  	P1,#0XA0
			LCALL 	DELAY
			RET					
;Delay Function 1s delay
DELAY:	MOV  	R7,#10
DEL1:	MOV		R6,#200
DEL2:	MOV		R5,#248
		DJNZ	R5,$
		DJNZ	R6,DEL2
		DJNZ	R7,DEL1
		RET
		END
		