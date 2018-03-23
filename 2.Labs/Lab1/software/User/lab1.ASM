; FileName		:		lab1.ASM	
; Author		:		Twsa Liu
; Date			:		2017-03-23
; Description	:		This is a lab ofm AT89C52RC.
;						The lab achieve function that include binkeying
;						,delay,light leds and switch using
 
;Main function
		ORG		0000H
INIT:	MOV 	P2,#0FFH
		MOV		P1,#0FFH		;init the I/O,make P1,P2 low
		MOV		A,#00H			;init accumulator A
		MOV		B,#00H	
		MOV		DPTR,#LED_TB	;int led table ptr		
LOOP:  	
		;LCALL	TEST1
		;LCALL	TEST2
		;LCALL	TEST3
		LCALL	TEST4		
		AJMP	LOOP		

;Light leds using switchs(P2)
TEST1:	MOV     P1,P2		;using switchligs to ht D1-D7
		RET

;Set a switch(P3.0) to control system 
WAIT:	JB		P3.0,WAIT	;if(P3.0=1) WAIT ,equal to bouncing the switch
TEST2:	JB		P3.0,WAIT	
		MOV     P1,P2
		JB		P3.0,WAIT
		RET	

;Binkly and contain operation of pasuing
WAIT1:	JB		P3.0,WAIT1
TEST3:	JB		P3.0,WAIT1
AGAIN:	MOVC	A,@A+DPTR
PASUE:	MOV 	P1,A			;PASUE operator
		JB		P3.0,PASUE
		LCALL 	DELAY
		MOV		A,B
		INC		B
		CJNE	A,#0X07,NEXT
		MOV		B,#0X00		;rest accumator A to zero
		RET
NEXT:	SJMP	AGAIN

;Binkly and contain operation of stopping
WAIT2:	JB		P3.0,WAIT2
TEST4:	JB		P3.0,WAIT2
AGAIN1:	MOVC	A,@A+DPTR
		MOV 	P1,A
		JB		P3.0,STOP
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
		JB		P3.0,STOP
		SJMP	TEST4
		
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
	
