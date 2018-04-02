	ORG	0000H
MAIN: 	LCALL 	DTEST	
		LCALL 	TEST2
		STOP:	SJMP	$
			
TEST1:	MOV		R0,#30H
		MOV		R1,#00H
		MOV		A,#0X77	
FIRST1:	MOV 	@R0,A	;创建链表头			
LOOP1:	MOV		A,R0	;创建一个节点
		MOV		R1,A	
		INC		R1		;R0指向当前节点，R1指向下一个节点
		MOV		A,@R0	;节点连接操作1
		MOV 	@R1,A	;节点连接操作2
		INC		R0      ;节点增加	
		MOV		A,R0
		CJNE	A,#3FH,LOOP1
		RET

;实现数据向向前推移动作
TEST2:	MOV		R0,#00H
		MOV		R1,#3FH
		MOV 	@R1,A	;创建链表头			
LOOP2:	MOV		A,R1	;创建一个节点
		MOV		R0,A	
		DEC		R0		;R0指向当前节点，R1指向下一个节点
		MOV		A,@R0	;节点连接操作1
		MOV 	@R1,A	;节点连接操作2
		DEC		R1      ;节点增加	
		DJNZ	R0,LOOP2
		RET	
DTEST:	CLR		A
		MOV		B,#00H
		MOV		R0,#30H
TE1:	MOV		R7,A
		MOV		@R0,A
		INC		R0
		MOV		A,B
		INC		A
		MOV		B,A
		CJNE	A,#0X10,TE1
		RET
END