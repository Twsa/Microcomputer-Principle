; FileName		:		lab5.ASM	
; Author		:		Twsa Liu
; Date			:		2018-05-09
; Description	:		This is a lab of AT89C52RC.
;						The lab achieve function extending I/O

;基础部分主程序
		ORG				0000H
		A_8255	EQU		3FFCH
		B_8255	EQU		3FFDH
		C_8255	EQU		3FFEH
		CN_8255	EQU		3FFFH
		CN_WORD	EQU		91H	
MAIN:	ACALL	INIT_8255
		ACALL	WAIT_START
LED:	ACALL	LED_CONTROL
		ACALL	WAIT_STOP
		SJMP	$
;Init the io extension  8255 block
;A 输入 B输出 C口高4位输出 C口低四位输入
INIT_8255:	MOV		A,#CN_WORD			;方式控制字送入A
			MOV		DPTR,#CN_8255		;控制寄存器地址
			MOVX	@DPTR,A				;8255A初始化	
			
			MOV		DPTR,#B_8255		;送端口B的地址
			MOV		A,#0X00
			MOVX	@DPTR,A				;熄灭LEDS	
			RET
			
TEST_WRITE:		MOV		DPTR,#B_8255	;送端口B的地址
				MOV		A,#0XCC
				MOVX		@DPTR,A		;写端口B	
				RET
				
WAIT_START:		MOV		DPTR,#C_8255		;送端口C的地址
				MOVX	A,@DPTR				;读C低四位端口
				ANL		A,#0X01
				CJNE	A,#0X01,WAIT_START
				RET
				
WAIT_STOP:		MOV		DPTR,#C_8255		;送端口C的地址
				MOVX	A,@DPTR				;读C低四位端口
				ANL		A,#0X02
				CJNE	A,#0X02,STOP
				SJMP 	LED
STOP:			MOV		DPTR,#B_8255		;送端口B的地址
				MOV		A,#0X00
				MOVX	@DPTR,A				;熄灭LEDS					
				RET
;读A控制B
LED_CONTROL:	MOV		DPTR,#A_8255		;送端口A的地址
				MOVX	A,@DPTR				;读A端口
				MOV		DPTR,#B_8255		;送端口B的地址
				MOVX	@DPTR,A				;写端口B	
				RET
				END