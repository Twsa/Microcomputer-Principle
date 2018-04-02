; FileName		:	.ASM	
; Author		:	Twsa Liu
; Date			:	2018-03-30
; Description	:	switch 0x01-0x0f t0 '1'-'f' and save to 50H
		ORG 0000H
MAIN:	
		LCALL	TEST
		;MOV		R7,#0X00
		;LCALL	DERR
;NEXT:	LCALL	DJUD
		;MOV		R7,A
STOP:	SJMP	$
;Judge the type  of data which user input,and select appropriate handle
DJUD:	MOV		A,R7
		CJNE	A,#0X0A,JUD1
JUD1:	MOV		A,PSW
		ANL		A,#0X80
		CJNE	A,#80H,HAL2
		ACALL	HAL1
		RET
HAL1:	MOV 	A,R7
		ADD		A,#0X30	
		RET
HAL2:	MOV 	A,R7
		ADD		A,#0X37	
		RET
;If data is illegal,and then program will stop
DERR:	MOV		A,R7					
		CJNE	A,#00H,DERR1  
DERR1:	MOV		A,PSW
		ANL		A,#0X80		  ;mov CY of PSW to A
		CJNE	A,#00H,STOP   ;If data is smaller than 0 ,STOP
		MOV		A,R7
		CJNE	A,#10H,DERR2	  	
DERR2:	MOV		A,PSW 
		ANL		A,#0X80
		CJNE	A,#00H,NEXT	  ;00h<=data<=0fh
		ACALL	STOP
;利用查表指令进行查找，并将16个结果保存在以50H开头的地址上		
TEST:	CLR		A
		MOV		B,#00H
		MOV		R0,#50H
TE1:	MOV		R7,A
		LCALL	DERR
NEXT:	LCALL	DJUD
		MOV		@R0,A
		INC		R0
		MOV		A,B
		INC		A
		MOV		B,A
		CJNE	A,#0X10,TE1
		ACALL	STOP
		END