		ORG		0000H
		LJMP	MAIN	
		ORG		0003H
		LJMP	INT_T0
		ORG		0013H
		LJMP	INT_T1

MAIN:	MOV		SP,#67H
		MOV		IE,#85H
		SETB	IT0
		SETB	IT1
		SETB	PX1
		MOV		A,#0FEH

LOOP:	MOV		P1,A
		RL		A
		MOV		R1,#20	  	;������ʱ����
		LCALL	DL	 
		LJMP	LOOP

INT_T0:	PUSH	ACC
		MOV		A,#0FFH
		MOV		P1,A
		MOV		R1,#20	  	;������ʱ����
		LCALL	DL
		CPL		A
		MOV		P1,A
		MOV		R1,#20	   	;������ʱ����
		LCALL	DL
		POP		ACC
		MOV		R1,#1

		RETI
			  
INT_T1:	PUSH	ACC
		MOV		A,#0FFH
		MOV		P1,A
		MOV		R1,#10	  	;������ʱ����
		LCALL	DL
		CPL		A
		MOV		P1,A
		MOV		R1,#10	   	;������ʱ����
		LCALL	DL
		POP		ACC
		MOV		R1,#1

		RETI
	
;��ʱ����	
DL:		MOV		R0,#250
DL2:	MOV		R2,#100
DL1:	DJNZ	R2,DL1
		DJNZ	R0,DL2
		DJNZ	R1,DL
		RET

		END






