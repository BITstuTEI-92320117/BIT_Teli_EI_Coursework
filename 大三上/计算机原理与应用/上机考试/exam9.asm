DATAS SEGMENT
    ; 数据段：无需额外数据，保持为空
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：无需显式使用堆栈，保持为空
STACKS ENDS

CODES SEGMENT
    ; 关联段寄存器：CS指向代码段，DS指向数据段，SS指向堆栈段
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
start:
    push ds         ; 保存DS寄存器初始值到堆栈
    sub ax, ax      ; 将AX寄存器清零（等价于mov ax, 0）
    push ax         ; 压入0作为程序结束时的返回地址（返回DOS）
    
    ; 主流程：输入二进制→换行→输出十进制→换行
    call input_bin  ; 调用二进制输入子程序，将输入转为16位二进制数存于BX
    call crlf       ; 调用回车换行子程序，优化输出格式
    call binidec    ; 调用二进制转十进制子程序，将BX中数值转为十进制输出
    call crlf       ; 再次调用回车换行，分隔结果与命令行
    
    ; 程序终止
    mov ah, 4ch     ; DOS功能号：程序正常退出
    int 21h         ; 执行DOS中断，结束程序


; ------------------- 复用第一个程序的子程序 -------------------
; 二进制输入子程序：读取键盘输入的0/1字符，转为16位二进制数存于BX
input_bin proc near
    mov bx, 0       ; 初始化BX为0，用于存储转换后的二进制结果
read_bit:
    mov ah, 1       ; DOS功能号：键盘字符输入（无回显，结果存于AL）
    int 21h         ; 执行中断，读取输入字符到AL
    
    ; 判断输入是否为有效二进制字符（0/1）
    cmp al, '0'     ; 比较输入字符与'0'
    je is_zero      ; 若为'0'，跳至is_zero处理
    cmp al, '1'     ; 比较输入字符与'1'
    je is_one       ; 若为'1'，跳至is_one处理
    jmp input_end   ; 若为非0/1字符（如回车），结束输入
    
is_zero:
    mov ax, 0       ; 当前位数值为0，存入AX
    jmp add_bit     ; 跳至add_bit，将当前位加入结果
is_one:
    mov ax, 1       ; 当前位数值为1，存入AX
    
add_bit:
    shl bx, 1       ; BX左移1位（等价于BX = BX × 2），为新位腾出最低位
    add bx, ax      ; 将当前位数值加入BX（BX = BX × 2 + 当前位）
    jmp read_bit    ; 跳转回read_bit，继续读取下一位
    
input_end:
    ret             ; 返回主程序调用处
input_bin endp


; ------------------- 复用第二个程序的子程序 -------------------
; 回车换行子程序：输出回车符（13）和换行符（10），优化输出格式
crlf proc near
    mov ah, 2       ; DOS功能号：字符输出（输出DL中的字符）
    mov dl, 13      ; DL赋值为13（回车符ASCII码）
    int 21h         ; 执行中断，输出回车符
    mov dl, 10      ; DL赋值为10（换行符ASCII码）
    int 21h         ; 执行中断，输出换行符
    ret             ; 返回主程序调用处
crlf endp


; 二进制转十进制子程序：将BX中16位二进制数按“万、千、百、十、个”位拆分并输出
binidec proc near
    mov cx, 10000d  ; CX赋值为10000（处理万位）
    call dec_div    ; 调用dec_div，计算并输出万位
    mov cx, 1000d   ; CX赋值为1000（处理千位）
    call dec_div    ; 调用dec_div，计算并输出千位
    mov cx, 100d    ; CX赋值为100（处理百位）
    call dec_div    ; 调用dec_div，计算并输出百位
    mov cx, 10d     ; CX赋值为10（处理十位）
    call dec_div    ; 调用dec_div，计算并输出十位
    mov cx, 1d      ; CX赋值为1（处理个位）
    call dec_div    ; 调用dec_div，计算并输出个位
    ret             ; 返回主程序调用处
binidec endp


; 十进制辅助计算子程序：计算当前位数值并输出，余数存回BX供后续位使用
dec_div proc near
    mov ax, bx      ; 将BX中的被除数送入AX（准备除法）
    mov dx, 0       ; DX清零，将AX扩展为32位被除数（DX:AX）
    div cx          ; DX:AX ÷ CX，商（当前位数值）存AX，余数存DX
    mov bx, dx      ; 将余数存入BX，供下一位计算使用
    mov dl, al      ; 将当前位数值（AX）送入DL（准备输出）
    add dl, 30h     ; 将数值转为ASCII码（0对应30H，9对应39H）
    mov ah, 2       ; DOS功能号：字符输出
    int 21h         ; 执行中断，输出当前位字符
    ret             ; 返回binidec调用处
dec_div endp


CODES ENDS
    END start       ; 程序结束，指定入口点为start
