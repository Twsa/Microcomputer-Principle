		ORG   0000H
		LJMP  MAIN	
		ORG  0050H
MAIN:   MOV   A,#17H
        MOV   R0,#18H
		MOV   R7,A
		INC   R5
		MOV   PSW,#10H  ;选中 第二组
		MOV   A, R0
		MOV   A,#12H
		MOV   DPTR, #1210H
		MOVX  @DPTR,A
	    MOV   DPTR, #0050H
		MOV   A,#00H
		MOVC  A,@A+DPTR
		SJMP   MAIN
		END
		
	