;
; Author		:	Twsa Liu
; Date			:	2017-03-14
; Description	:	ѧϰʹ������� 

;MAIN
LOOP: 
SETB 	P1.0		;(1)(Ϩ���)
LCALL 	DELAY		;(2)�ӳ�һ��ʱ��
CLR 	P1.0		;(3)������
LCALL 	DELAY		;(2)�ӳ�һ��ʱ��
AJMP	LOOP		;(5)��ת����һ��LOOP��

;Sub Function
DELAY:
MOV 	R7,#250		
D1:
MOV 	R6,#250	
D2:		
DJNZ	 R6,D2
	DJNZ 	R7,D1
	RET				;�ӳ��򷵻أ��ص����ô�
END
	