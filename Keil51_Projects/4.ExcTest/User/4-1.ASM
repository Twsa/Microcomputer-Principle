	ORG	0000H
INIT:	MOV		R0,#30H
		MOV		R1,#00H
		MOV		A,#0X77	
FIRST:	MOV 	@R0,A	;创建链表头			
LOOP:	MOV		A,R0	;创建一个节点
		MOV		R1,A	
		INC		R1		;R0指向当前节点，R1指向下一个节点
		MOV		A,@R0	;节点连接操作1
		MOV 	@R1,A	;节点连接操作2
		INC		R0      ;节点增加	
		MOV		A,R0
		CJNE	A,#3FH,LOOP
END