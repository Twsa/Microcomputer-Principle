; FileName		:	exc3.ASM	
; Author		:	Twsa Liu
; Date			:	2018-03-28
; Description	:	This is the third exercise,
;					target are 3-7,3-8,3-9,3-10 
;					at page 83 in textbook    

;Init
		ORG		0000H
MAIN:	
	LCALL	TG4
	SJMP	MAIN
	
;target 3-7 
;要求：分析下列指令执行结果及对PSW中标志位的影响
TG1:	
		;0A8H=10101000B中1的个数共有3个为
		;奇数位，奇偶校验位P为1
		MOV		A,#0A8H		
		;P66带进位的加法指令,
		;与ADD等同，同时指令执行之前加上进位标志C
		;主要应用在多字节的加法运算
		;上一次操作没有产生CY=1，因此ADDC操作+C=0
		;低半字节向高半字节产生进位 AC=1
		;产生进位CY=1
		ADDC	A,#5DH
		RET
;target 3-8
;分析下列程序中各条指令的执行结果
TG2:	MOV		A,#0F3H		;(A)=0F3H
		MOV		50H,#34H	;(50H)=34H
		ANL		A,50H		;(A) and (50H)=F3H and 34H=30H
		ANL		A,#0FH		;(A) and 0FH=30H and 0FH=00H
		ORL		A,#07H		;(A) or 07H=00H or 07H=07H
		XRL		A,50H		;(A) xor (50H)=07H xor 34H=33H
		RET

;taget 3-9
;要求：写出实现下列要求的所需要的指令或程序段
TG3:
		;(1)将R0的内容传送到R2
		;寄存器R之间不能直接传递数据的,只能通过累加器A来传递数据
		MOV		R0,#45H ;清明节
		MOV		A,R0
		MOV		R2,A
		;(2)将内部的RAM的98H单元的内容传送到R6
		MOV 	98H,#51H  ;劳动节 
		MOV		R6,98H
		;(3)将外部程序存储器8000H单元
		;内容传送到内部RAM的60H单元
		MOV		A,#11H	;元旦
		MOV		DPTR,#8000H
		MOVX	@DPTR,A
		CLR		A
		MOVX	A,@DPTR
		MOV		60H,A
		;(4)将程序存储器4000H单元的
		;内容传送到内部RAM的60H单元
		MOV		DPTR,#4000H
		CLR		A
		MOVC	A,@A+DPTR
		MOV		60H,A
		;(5)将累加器高4位清0、
		;低4位不变
		MOV		A,#35H 	;元宵节
		ANL		A,#0FH
		;(6)将内部RAM的20H单元的
		;D6和D2位取反，其余位不变
		;45H=0100 0101B,D6和D2取反后 
		;0000 0001B=01H
		MOV		20H,#45H
		MOV		A,20H
		ANL		A,#0XBB
		MOV		20H,A
		RET
;target 3-10
;要求：试编写程序完成将内部的RAM的90H为首地址的
;	   20个数据传送到外部RAM的9000H为首地址的区域
;51系列，片内RAM范围为00H~7FH，是128字节；80H～FFH被特殊功能寄存器使用了。
;52系列，片内RAM范围为00H~FFH，是256字节；但是为了兼容51，
;特殊功能寄存器仍然是80H~FFH，这就出现了问题，
;80H~FFH既是特殊功能寄存器又是RAM，怎么办？
;于是聪明的设计工程师们就规定，在80H~FFH范围内，访问RAM必须用间接寻址。
TG4:	
INIT4:	ACALL	TEST4
		MOV 	DPTR,#9000H
		MOV		R0,#90H
		MOV		R7,#00H  
NEXT4:	MOV		A,@R0
		MOVX 	@DPTR,A
		INC		DPTR
		INC		R0
		INC		R7
		CJNE	R7,#0X14,NEXT4	;Dec 20
		SJMP	$
		RET
TEST4:	MOV		R0,#90H
		CLR		A
TE4LP:	MOV		@R0,A
		INC		A
		INC		R0
		CJNE 	R0,#0A4H,TE4LP	
		RET
END	