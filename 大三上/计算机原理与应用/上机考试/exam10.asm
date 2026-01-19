DATAS SEGMENT
    ;定义数据段，本程序未使用数据，故为空
DATAS ENDS

STACKS SEGMENT
    ;定义堆栈段，本程序未显式使用堆栈，故为空
STACKS ENDS

CODES SEGMENT
    ;定义代码段，并关联段寄存器：CS指向CODES，DS指向DATAS，SS指向STACKS
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    start: push ds        ;保存DS寄存器值到堆栈
    sub ax, ax           ;将AX清零（等价于mov ax,0）
    push ax              ;将0压入堆栈，作为程序结束时的返回地址
    my_repeat:           ;循环处理标签（当前被注释的jmp禁用了循环）
    call hexibin ; 16→2  ;调用hexibin过程，将十六进制输入转换为二进制（存于BX）
    call crlf ;回车换行，略;调用crlf过程，输出回车换行
    call binidec ; 2→10  ;调用binidec过程，将BX中的二进制转换为十进制输出
    call crlf            ;再次调用crlf，输出回车换行
    ;jmp my_repeat       ;跳回my_repeat实现重复输入输出（当前注释禁用）
    mov ah, 4ch          ;DOS功能调用号：程序终止
    int 21h              ;执行DOS调用，结束程序
    
    crlf proc  near      ;定义crlf过程（近过程），功能：输出回车换行
    mov ah, 2            ;DOS功能号：字符输出
    mov dl, 13           ;DL=13（回车符ASCII码）
    int 21h              ;输出回车符
    mov dl, 10           ;DL=10（换行符ASCII码）
    int 21h              ;输出换行符
    ret                  ;返回调用处
    crlf   endp          ;crlf过程结束
    
    hexibin proc near    ;定义hexibin过程（近过程），功能：读取十六进制字符并转换为二进制（结果存于BX）
    mov bx, 0            ;初始化BX为0，用于存储转换结果
    newchar: mov ah, 1   ;DOS功能号：字符输入
    int 21h              ;读取键盘输入字符，存于AL
    sub al, 30h          ;将ASCII码转换为数值（0-9的ASCII码减30h得对应数值）
    jl exit              ;若结果小于0（非数字/字母字符，如回车），跳至exit结束转换
    cmp al, 10           ;比较数值与10
    jl add_to            ;若小于10（是0-9），跳至add_to处理
    sub al, 07h          ;否则处理A-F/a-f：A(41h)减30h得11h，再减27h得0Ah（对应10），a同理
    cmp al, 0ah          ;比较数值与10（0Ah）
    jl exit              ;若小于10（非法字符），跳至exit
    cmp al, 10h          ;比较数值与16（10h）
    jge exit             ;若大于等于16（非法字符），跳至exit
    add_to: mov cl, 4    ;CL=4，用于移位操作
    shl bx, cl           ;BX左移4位（等价于BX=BX*16），为新输入的十六进制位留位置
    mov ah, 0            ;AH清零，将AL扩展为AX（16位）
    add bx, ax           ;BX = BX*16 + 新输入的数值（完成一位十六进制的累加）
    jmp newchar          ;跳转至newchar，继续读取下一个字符
    exit: ret            ;返回调用处
    hexibin endp         ;hexibin过程结束

    binidec proc near    ;定义binidec过程（近过程），功能：将BX中的二进制数转换为十进制并输出
    mov cx, 10000d       ;CX=10000，准备获取万位数字
    call dec_div         ;调用dec_div过程，输出万位
    mov cx, 1000d        ;CX=1000，准备获取千位数字
    call dec_div         ;调用dec_div过程，输出千位
    mov cx, 100d         ;CX=100，准备获取百位数字
    call dec_div         ;调用dec_div过程，输出百位
    mov cx, 10d          ;CX=10，准备获取十位数字
    call dec_div         ;调用dec_div过程，输出十位
    mov cx, 1d           ;CX=1，准备获取个位数字
    call dec_div         ;调用dec_div过程，输出个位
    ret                  ;返回调用处
    binidec endp         ;binidec过程结束
    
    dec_div proc near    ;定义dec_div过程（近过程），功能：将BX中的数除以CX，输出商（对应位数字），余数存回BX
    mov ax, bx           ;AX=BX（将被除数存入AX）
    mov dx, 0            ;DX=0（扩展被除数为32位：DX:AX）
    div cx               ;DX:AX ÷ CX，商存于AX，余数存于DX
    mov bx, dx           ;BX=余数（用于后续低位计算）
    mov dl, al           ;DL=商（当前位的数字）
    add dl, 30h          ;将数字转换为ASCII码（0的ASCII码为30h）
    mov ah, 2            ;DOS功能号：字符输出
    int 21h              ;输出当前位的ASCII字符
    ret                  ;返回调用处
    dec_div endp         ;dec_div过程结束
CODES ENDS
    END START            ;程序结束，指定入口点为START

