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
    call bin_to_hex ; 调用bin_to_hex：将BX中二进制数转为十六进制输出
    call crlf       ; 输出回车换行
    
    mov ah, 4ch     ; DOS功能：程序终止
    int 21h         ; 执行终止调用


; 回车换行子程序（复用参考程序）：输出回车符(13)和换行符(10)
crlf proc near
    mov ah, 2       ; DOS功能号：字符输出
    mov dl, 13      ; 回车符ASCII码
    int 21h
    mov dl, 10      ; 换行符ASCII码
    int 21h
    ret
crlf endp


; 新增子程序：读取十进制字符（0-9），转换为16位二进制数存于BX
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
    push ax         ; 保护AX
    mov ax, bx      ; 将BX移入AX准备相乘
    
    ; 计算BX = BX×10 + 当前数值（实现十进制累加）
    mov cx, 10      ; CX=10，用于乘法
    mul cx          ; AX = 当前数值×10（临时存储中间结果）
    mov bx, ax      ; 将AX的结果移回BX
    pop ax          ; 恢复AX的值
    add bx, ax      ; BX = 原BX×10 + 当前数值（完成十进制位累加）
    
    jmp read_digit  ; 继续读取下一位数字
input_end:
    ret
input_dec endp


; 二进制转十六进制子程序（复用参考程序）：将BX中16位二进制数转为十六进制输出（4位）
bin_to_hex proc near
    mov ch, 4       ; 16位二进制对应4位十六进制，循环4次
rotate:
    mov cl, 4       ; 每次处理4位，移位量为4
    rol bx, cl      ; BX循环左移4位，将待处理的4位移到低4位
    mov al, bl      ; 取BX低8位到AL
    and al, 0fh     ; 保留低4位（屏蔽高4位）
    add al, 30h     ; 转换为'0'~'9'的ASCII码（30H~39H）
    cmp al, 3ah     ; 判断是否为10~15（对应'A'~'F'）
    jl printit      ; 若为0~9，直接输出
    add al, 7h      ; 转换为'A'~'F'的ASCII码（3AH+7H=41H即'A'）
printit:
    mov dl, al      ; 待输出字符存入DL
    mov ah, 2       ; DOS功能号：字符输出
    int 21h         ; 输出当前十六进制位
    dec ch          ; 计数器减1
    jnz rotate      ; 未处理完4位则继续循环
    ret
bin_to_hex endp


CODES ENDS
    END start       ; 程序结束，入口点为start
