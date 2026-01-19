DATAS SEGMENT

DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体内容，使用默认堆栈）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           ; 初始化数据段寄存器，让DS指向数据段
    MOV DS,AX
    
    mov cx, 10             ; 循环计数器cx设为10（需输入10个十进制数）
    mov ax, 0              ; ax用于统计“100以上”的数的个数，初始化为0
    mov dx, 0              ; dx拆分使用：dl统计“0-9”个数，dh统计“10-99”个数，初始均为0
L1:                        ; 循环入口：输入10个数并分类统计
    call input_dec         ; 调用子程序，从键盘输入一个十进制数，结果存入bx
    
    ; 判断当前输入的数（bx）所属区间，更新对应计数器
    cmp bx, 9              ; 比较bx与9（判断是否在“0-9”区间）
    jbe L2                 ; 若≤9，跳至L2（更新0-9计数器）
    cmp bx, 99             ; 比较bx与99（判断是否在“10-99”区间）
    jbe L3                 ; 若≤99，跳至L3（更新10-99计数器）
    jmp L4                 ; 若>99，跳至L4（更新100以上计数器）

L2:                        ; 处理“0-9”区间的数
    inc dl                 ; 0-9计数器dl加1
    jmp L5                 ; 跳至循环控制，准备下一次输入
L3:                        ; 处理“10-99”区间的数
    inc dh                 ; 10-99计数器dh加1
    jmp L5                 ; 跳至循环控制
L4:                        ; 处理“100以上”区间的数
    inc al                 ; 100以上计数器al加1
L5:                        ; 循环控制
    loop L1                ; cx减1，若不为0则继续循环输入下一个数

    ; 依次显示三个区间的统计结果
    call output            ; 显示dl（0-9的个数）
    call crlf              ; 输出回车换行，分隔结果
    mov dl, dh             ; 将10-99的个数（dh）移入dl，准备显示
    call output            ; 显示10-99的个数
    call crlf              ; 回车换行
    mov dl, al             ; 将100以上的个数（al）移入dl，准备显示
    call output            ; 显示100以上的个数
    call crlf              ; 回车换行

    ; 程序结束，返回DOS
    MOV AH,4CH
    INT 21H

; 子程序：input_dec - 从键盘输入一个十进制数，转换为二进制数存入bx
input_dec proc near
    mov bx, 0              ; 初始化bx为0，用于存储输入的十进制数（二进制形式）
    push ax                ; 保存主程序中的ax值（避免子程序修改）
    push cx                ; 保存主程序中的cx值
    push dx                ; 保存主程序中的dx值
read_digit:                ; 循环读取单个数字字符
    mov ah, 01h            ; DOS功能调用：单个字符输入（01H），输入字符存入al
    int 21h                ; 执行输入
    
    ; 判断输入的字符是否为数字（'0'-'9'）
    cmp al, '0'            ; 比较输入字符与'0'
    jl input_end           ; 若小于'0'（非数字，如回车），结束输入
    cmp al, '9'            ; 比较输入字符与'9'
    jg input_end           ; 若大于'9'（非数字），结束输入
    
    ; 将数字字符转换为数值，并拼接成完整十进制数
    sub al, 30h            ; ASCII码转数值（'0'-'9'→0-9）
    mov ah, 0              ; 清空ah，使ax=当前数字（8位→16位扩展）
    push ax                ; 保存当前数字，避免后续操作覆盖
    
    mov ax, bx             ; 将已拼接的数（bx）移入ax
    mov cx, 10             ; cx=10，用于实现“乘以10”（左移一位十进制）
    mul cx                 ; ax = ax × 10（已拼接的数扩大10倍，腾出个位）
    mov bx, ax             ; 将扩大后的数存回bx
    
    pop ax                 ; 恢复当前数字到ax
    add bx, ax             ; 将当前数字加到bx的个位，完成一次拼接
    jmp read_digit         ; 继续读取下一个数字字符
input_end:                 ; 输入结束，恢复主程序寄存器
    pop dx                 ; 恢复dx原值
    pop cx                 ; 恢复cx原值
    pop ax                 ; 恢复ax原值
    ret                    ; 返回主程序
input_dec endp

; 子程序：crlf - 输出回车（13）和换行（10），实现换行功能
crlf proc near
    push ax                ; 保存主程序ax值
    push dx                ; 保存主程序dx值
    mov ah, 02h            ; DOS功能调用：字符输出（02H）
    mov dl, 13             ; dl=13（回车符ASCII码）
    int 21h                ; 输出回车
    mov ah, 02h            ; 再次调用字符输出功能
    mov dl, 10             ; dl=10（换行符ASCII码）
    int 21h                ; 输出换行
    pop dx                 ; 恢复dx原值
    pop ax                 ; 恢复ax原值
    ret                    ; 返回主程序
crlf endp

; 子程序：output - 将dl中的计数器值（0-10）转换为ASCII码并显示
output proc near
    push ax                ; 保存主程序ax值
    push dx                ; 保存主程序dx值（避免修改原计数器）
    add dl, 30h            ; 数值转ASCII码（0-9→'0'-'9'，10→3Ah）
    
    ; 判断计数器值是否为10（因最多输入10个数，单个计数器最大为10）
    cmp dl, 3ah            ; 3Ah是10的ASCII码（10+30h=3Ah）
    je L6                  ; 若等于10，跳至L6（特殊处理，显示“10”）
    
    ; 若计数器值为0-9，直接显示单个字符
    mov ah, 02h            ; 字符输出功能
    int 21h                ; 显示字符
    jmp L7                 ; 跳至子程序结束，避免执行L6
L6:                        ; 处理计数器值为10的情况（显示“10”）
    mov dl, 31h            ; dl='1'（ASCII 31h）
    mov ah, 02h            ; 输出'1'
    int 21h    
    mov dl, 30h            ; dl='0'（ASCII 30h）
    mov ah, 02h            ; 输出'0'
    int 21h
L7:                        ; 子程序结束，恢复寄存器
    pop dx                 ; 恢复dx原值（原计数器值）
    pop ax                 ; 恢复ax原值
    ret                    ; 返回主程序
output endp 
CODES ENDS
    END START
