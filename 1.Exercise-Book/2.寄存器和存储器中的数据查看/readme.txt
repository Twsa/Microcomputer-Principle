作业要求：
查找三种存储器内部数据的方法
1、内部数据存储器存储器 D/d
2、外部数据存储器（外部RAM或者I/O接口）X/x
3、程序存储器 （外部ROM） C/c
根据附件中的程序，利用KEIL软件观察每个指令的执行结果。

RAM:随机存取存储器（Random Access Memory），一种电脑内存。
ROM:只读内存（Read-Only Memory），用于电脑和其它电子设备的一种内存

51单片机的工作寄存器一共有32个，为RAM中的00H--1FH单元，分为4组，分别是
0组：00H--07H单元、
1组：08H--0FH单元、
2组：10H--17H单元、
3组：18H--1FH单元，
每组的8个单元分别对应R0--R7。这四组中只有一组是当前工作寄存器,
程序中使用的就是当前工作寄存器中的8个单元。
当前工作寄存器是由程序状态字PSW中的第三第四位决定的。
在PSW中，的PSW4、PSW3两位组合的00、01、10、11四个状态，
00、01、10、11
0组、1组、2组、3组
分别指定工作寄存器的0组、1组、2组、3组，只需要用指令改变PSW的这两位状态，
就可以改变当前工作寄存器组。这样，实际上就是有32个工作寄存器可以选用。

结果：
1.（LJMP MAIN）跳转到标签（MAIN）
2. (MOV A,#17H)给累加器A赋值（17H）
3.（MOV   R0,#18H）给工作寄存器R0赋值（18H),默认第一组工作寄存器
4.（MOV   R7,A）把累加器A中的值赋给工作寄存器R7
5.（INC   R5）工作寄存器R5自加1
6.（MOV   PSW,#10H）选中 第二组工作寄存器
7.（MOV   A, R0）把工作寄存器R0中的值赋给累加器A,已经选为第二组工作寄存器，初始值为0，所以A中的值为0
8. (MOV   A,#12H) 给A赋值12H
9. (MOV   DPTR, #1210H) 把地址1210H赋给指针DPTR
10. (MOVX  @DPTR,A)将累加器 A 的数据送数据指针 DPTR 寄存器所指外部 RAM地址单元内	
11.(MOV   DPTR, #0050H)把地址0050H赋给指针DPTR
12.(MOV   A,#00H) 累加器A清空
13.(MOVC  A,@A+DPTR)A+DPTR 构成 ROM 地址,将该地址内的数据送累加器 A内
14.(SJMP   MAIN)跳转到MAIN

