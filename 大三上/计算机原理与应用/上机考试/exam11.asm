DATAS SEGMENT
    ; 数据段：本程序无需额外数据，保持为空
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：保持为空
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
start:
    push ds         ; 保存DS寄存器
    sub ax, ax      ; AX清零
    push ax         ; 压入返回地址0
    call hexibin    ; 调用hexibin：读取十六进制输入并转为二进制（结果存于BX）
    call crlf       ; 输出回车换行
    call bintobin   ; 调用bintobin：将BX中的二进制数（16位）以二进制形式输出
    call crlf       ; 输出回车换行
    mov ah, 4ch     ; 程序终止
    int 21h

; 回车换行子程序（复用原程序）
crlf proc near
    mov ah, 2       ; DOS功能：字符输出
    mov dl, 13      ; 回车符ASCII码
    int 21h
    mov dl, 10      ; 换行符ASCII码
    int 21h
    ret
crlf endp

; 十六进制转二进制子程序（复用原程序）：从键盘读入十六进制字符，转换为16位二进制数存于BX
hexibin proc near
    mov bx, 0       ; 初始化结果寄存器BX为0
newchar:
    mov ah, 1       ; DOS功能：字符输入
    int 21h         ; 读入字符存于AL
    sub al, 30h     ; ASCII码转数值（0-9）
    jl exit         ; 若小于0（非有效字符，如回车），退出转换
    cmp al, 10      
    jl add_to       ; 若为0-9，直接累加
    sub al, 07h     ; 转换A-F/a-f为10-15（A的ASCII码41h-30h=11h，再减27h=0Ah）
    cmp al, 0ah     
    jl exit         ; 若小于10（非法字符），退出
    cmp al, 10h     
    jge exit        ; 若大于等于16（非法字符），退出
add_to:
    mov cl, 4       
    shl bx, cl      ; BX左移4位（等价于×16），为新数留位置
    mov ah, 0       
    add bx, ax      ; BX = BX×16 + 新输入的数值
    jmp newchar     ; 继续读下一个字符
exit:
    ret
hexibin endp

; 新增子程序：将BX中的16位二进制数以二进制形式输出（共16位，含前导0）
bintobin proc near
    mov ax, bx      ; 用AX暂存BX的值（避免修改BX原始数据）
    mov cx, 16      ; 计数器：需输出16位二进制数
next_bit:
    shl ax, 1       ; 左移1位，最高位进入进位标志CF
    mov dl, '0'     ; 默认为字符'0'
    jnc output      ; 若CF=0，直接输出'0'
    mov dl, '1'     ; 若CF=1，改为输出'1'
output:
    push ax
    mov ah, 2       ; DOS功能：字符输出
    int 21h         ; 输出当前位
    pop ax        
    loop next_bit   ; 循环16次，输出所有位
    ret
bintobin endp

CODES ENDS
    END start

