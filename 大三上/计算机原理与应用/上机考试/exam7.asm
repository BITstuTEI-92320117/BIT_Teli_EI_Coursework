DATAS SEGMENT
    ; 数据段：无需额外数据，保持为空
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：保持为空
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
start:
    push ds         ; 保存DS寄存器
    sub ax, ax      ; AX清零
    push ax         ; 压入返回地址0（程序结束时返回DOS）
    
    call input_dec  ; 调用input_dec：读取十进制输入并转为16位二进制数（存于BX）
    call crlf       ; 输出回车换行
    call bintobin   ; 调用bintobin：将BX中的16位二进制数以二进制形式输出
    call crlf       ; 输出回车换行
    
    mov ah, 4ch     ; DOS功能：程序终止
    int 21h         ; 执行终止调用


; 回车换行子程序（复用两个程序的共同逻辑）：输出回车符和换行符
crlf proc near
    mov ah, 2       ; DOS功能号：字符输出
    mov dl, 13      ; 回车符ASCII码
    int 21h
    mov dl, 10      ; 换行符ASCII码
    int 21h
    ret
crlf endp


; 十进制输入转换子程序（复用第一个程序）：读取十进制字符（0-9），转为16位二进制数存于BX
input_dec proc near
    mov bx, 0       ; 初始化结果寄存器BX为0（存储转换后的二进制数）
read_digit:
    mov ah, 1       ; DOS功能号：字符输入
    int 21h         ; 读取键盘输入，字符存于AL
    
    cmp al, '0'     ; 检查是否为'0'~'9'
    jl input_end    ; 若小于'0'（非数字字符，如回车），结束输入
    cmp al, '9'
    jg input_end    ; 若大于'9'（非数字字符），结束输入
    
    sub al, 30h     ; 将ASCII码转换为数值（0-9）
    mov ah, 0       ; AH清零，将AL扩展为AX（16位数值）
    push ax         ; 保护AX（当前数字）
    mov ax, bx      ; 将BX（累计结果）移入AX准备乘法
    
    ; 计算BX = BX×10 + 当前数值（实现十进制累加）
    mov cx, 10      ; CX=10，用于乘法
    mul cx          ; AX = 累计结果×10
    mov bx, ax      ; 将乘法结果移回BX
    pop ax          ; 恢复AX（当前数字）
    add bx, ax      ; BX = 累计结果×10 + 当前数字（完成累加）
    
    jmp read_digit  ; 继续读取下一位数字
input_end:
    ret
input_dec endp


; 二进制输出子程序（复用第二个程序）：将BX中的16位二进制数以二进制形式输出（共16位，含前导0）
bintobin proc near
    mov ax, bx      ; 用AX暂存BX的值（避免修改原始数据）
    mov cx, 16      ; 计数器：需输出16位二进制数
next_bit:
    shl ax, 1       ; 左移1位，最高位进入进位标志CF
    mov dl, '0'     ; 默认为字符'0'
    jnc output      ; 若CF=0（最高位为0），直接输出'0'
    mov dl, '1'     ; 若CF=1（最高位为1），改为输出'1'
output:
    push ax         ; 保护AX（避免输出中断影响计数器）
    mov ah, 2       ; DOS功能号：字符输出
    int 21h         ; 输出当前位
    pop ax          ; 恢复AX
    loop next_bit   ; 循环16次，输出所有位
    ret
bintobin endp


CODES ENDS
    END start       ; 程序结束，入口点为start
