; FileName		:	exc4.ASM	
; Author		:	Twsa Liu
; Date			:	2018-03-30
; Description	:	This is the forth exercise,
;					target are 4-1,4-11 
;					at page 113,114 in textbook    

;Init
		ORG		0000H
MAIN:	
	LCALL	TG1
	SJMP	$
;target 4-1
;要求：编写数据块传送程序，将片内RAM的50H地址开始的100字节送到
;		片外RAM的3000H开始的单元
TG1:	
INIT1:	ACALL	TEST1
		MOV 	DPTR,#3000H
		MOV		R0,#50H
		MOV		R7,#00H  
NEXT1:	MOV		A,@R0
		MOVX 	@DPTR,A
		INC		DPTR
		INC		R0
		INC		R7
		CJNE	R7,#100D,NEXT1	;Dec 20
		SJMP	$
		RET
TEST1:	MOV		R0,#50H
		CLR		A
TE1LP:	MOV		@R0,A
		INC		A
		INC		R0
		CJNE 	R0,#0B4H,TE1LP	;50H+64H
		RET

;target 4-10
;要求：试设计一个子程序，其功能是应用查表指令“MOVC A,@A+PC”
;	   求累加器（A）的平方值，结果送入A，入口时（A）<15
TG2:	MOV		A,#0X01
		ADD		A,#0AH
		MOVC	A,@A+PC
		RET
		DB 	00H,01H,04H,09H,10H,19H,24H,31H,\
			40H,51H,64H,79H,90H,0A9H,0C4H,0E1H

END
