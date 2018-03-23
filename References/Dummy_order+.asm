      RUN    BIT   P3.0      ;P3.0 
	  TAB    EQU    1000H  
	  ORG    0000H
	  LJMP   MAIN	
	  ORG    0050H
MAIN: MOV    DPTR,  #TAB    
      CPL    RUN 
      JNB    RUN, NEXT	     ;
      MOV    A,   #0FFH   	 ;		
      MOV    P1,  A          ;
      SJMP   MAIN            ;
NEXT: MOV    A,   P2	        
      MOV    P1,  A 	        
      JMP    MAIN 
	  
	  ORG   0088H
      DB     -2,-4,-6,8,10,18
      ORG   0098H
 Step_number: DB   34H,56H,67H,58H,12H,18H
	   DATA1: DW   324AH,3CH
		 TBL: DS    08H
       DATA2: DW   324AH,3CH
		   
      END
