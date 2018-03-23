     ORG	0000H
MAIN: 		MOV	A,#0H
		MOV	B,#0
		MOV	DPTR,#LED_Y    ;初始化指针

NEXT: 		MOV	A,B
		MOVC	A,@A+DPTR
		MOV	P1,A
		INC	B
		MOV	A,B
		CJNE	A,#8,AGAIN0
		MOV	B,#0
	
AGAIN0:		LCALL	DELAY_1000ms
	
		
	              SJMP	NEXT

;延时子程序
DELAY_1000ms: MOV	R7,#5
DELAY_200ms:  MOV 	R5,#200   ;12MHz  
  DELAY_1ms:  MOV 	R4,#249   ;12MHz
         DL:  NOP       
	      NOP
	      DJNZ	R4,DL
	      DJNZ	R5,DELAY_1ms
	      DJNZ	R7,DELAY_200ms	
	      RET




LED_Y:  DB  0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H
	

	        END







	