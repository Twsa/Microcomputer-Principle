大作业题目：多路数字式温度采集系统的设计
查找三种存储器内部数据的方法
1、内部数据存储器存储器 D/d
2、外部数据存储器（外部RAM或者I/O接口）X/x
3、程序存储器 （外部ROM） C/c

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

Keil与Proteus 联合调试
参考链接：https://blog.csdn.net/yagnruinihao/article/details/45843341
(1)将D:\Tool_engineer\proteus\MODELS\VDM51.dll 复制到keil的目录D:\Tool_engineer\KEIL4\C51\BIN中。

如果发现没有VDM51.dll可到这里下载 ： http://pan.baidu.com/s/1o6C9kEI

（2）记事本打开D:\Tool_engineer\KEIL4\TOOLS.INI,然后在【c51】后面加上：
TDRV5=BIN\VDM51.DLL ("Proteus VSM Monitor-51 Driver")
这里的“5”要根据实际情况修改，只要和之前的不重复，就可以。

程序状态字PSW 课本P30
