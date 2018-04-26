;0000H  开始的存储单元幅值

STR_1:  MOV   DPTR,#8000H
      	MOV	  A,#01
      	MOV	  R7,#16

LOOP_1: MOVX  @DPTR,A       
      	INC   DPTR
      	INC	   A
	    DJNZ   R7, LOOP_1
		
		
STR_2:  MOV   DPTR,#0A000H   
      	MOV	  R7,#16

LOOP_2: MOVX  @DPTR,A       
      	INC   DPTR 
      	INC	   A
	    DJNZ   R7, LOOP_2
		
		

      	MOV   DPTR,#2000H
	    MOV	  R0,#30H
      	MOV	  R7,#16

NEXT: 	MOVX  A,@DPTR   
     	MOV    @R0,A    
	    INC	  DPTR
      	INC	  R0
	    DJNZ	 R7,NEXT
        END