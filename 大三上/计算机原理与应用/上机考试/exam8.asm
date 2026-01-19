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
    
    call input_bin  ; 调用input_bin：读取二进制输入并转为16位二进制数（存于BX）
    call crlf       ; 输出回车换行
    call bin_to_hex ; 调用bin_to_hex：将BX中二进制数转为十六进制输出
    call crlf       ; 输出回车换行
    
    mov ah, 4ch     ; DOS功能：程序终止
    int 21h         ; 执行终止调用


; 回车换行子程序：输出回车符(13)和换行符(10)
crlf proc near
    mov ah, 2       ; DOS功能号：字符输出
    mov dl, 13      ; 回车符ASCII码
    int 21h
    mov dl, 10      ; 换行符ASCII码
    int 21h
    ret
crlf endp


; 新增子程序：读取二进制字符（0/1），转换为16位二进制数存于BX
input_bin proc near
    mov bx, 0       ; 初始化结果寄存器BX为0（存储转换后的二进制数）
read_bit:
    mov ah, 1       ; DOS功能号：字符输入
    int 21h         ; 读取键盘输入，字符存于AL
    
    cmp al, '0'     ; 检查是否为'0'
    je is_zero
    cmp al, '1'     ; 检查是否为'1'
    je is_one
    jmp input_end   ; 若为非0/1字符（如回车），结束输入
    
is_zero:
    mov ax, 0       ; 当前位数值为0
    jmp add_to_bx
is_one:
    mov ax, 1       ; 当前位数值为1
add_to_bx:
    shl bx, 1       ; BX左移1位（等价于×2），为新位腾出最低位
    add bx, ax      ; 将当前位数值加入BX（BX = BX×2 + 新位数值）
    jmp read_bit    ; 继续读取下一位
input_end:
    ret
input_bin endp


; 复用提供的代码：将BX中16位二进制数转为十六进制输出（4位十六进制数）
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
