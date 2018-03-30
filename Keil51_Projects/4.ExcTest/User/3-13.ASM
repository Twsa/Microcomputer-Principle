	ORG 0000H
	MOV	R2,#77H
	MOV	A,R2
	MOV	23H,#08
	MOV	R1,#00H
	MOV R3,#00H   ;tmp rigister
MAIN:	LCALL	LEFT
JUD:	DJNZ	23H,MAIN
STOP:	SJMP	STOP

;向左移位，出位
LEFT:	MOV B,A
		ANL	A,#0X80		;对A中的内容与0x80进行与操作取最高位	
		LCALL RIGHT
		MOV	A,B			;获取被操作数据
		RL	A			;被操作数据左移	
		RET
;向右移数据，进位
RIGHT:	ORL A,R3		;将最高位数据与之前右移的数据进行或
		MOV	R1,A	
		MOV	A,R1
		RR 	A
		MOV R3,A
		RET
		END
		