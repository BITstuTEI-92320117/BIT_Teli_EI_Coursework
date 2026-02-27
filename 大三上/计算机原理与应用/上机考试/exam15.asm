DATAS SEGMENT
    num db 38H, 4AH, 0C5H, 83H, 9CH, 0B4H, 7FH, 0C4H, 05H, 0F5H  ; 定义包含10个有符号字节数的数组（补码表示）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体内容，使用默认堆栈）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
;-431,6
    MOV AX,DATAS           ; 初始化数据段寄存器
    MOV DS,AX
    mov si, 0              ; 变址寄存器si初始化为0（指向数组第一个元素）
    mov cx, 10             ; 循环计数器cx设为10（数组共10个元素）
    mov ax, 0              ; ax用于统计负数的个数，初始化为0
    mov bx, 0              ; bx用于累加负数的绝对值之和，初始化为0
L1:                        ; 循环处理数组中的每个元素
    mov dl, num[si]        ; 将当前元素（num[si]）存入dl
    cmp dl, 0              ; 比较当前元素与0（判断是否为负数）
    jnl L2                 ; 若当前元素非负（大于等于0），跳至L2（不处理）
    neg dl                 ; 若为负数，求其绝对值（neg指令对补码取反加1，得到绝对值）
    mov dh, 0              ; dh清零，使dx=dl（将8位绝对值扩展为16位，便于累加）
    add bx, dx             ; 将当前负数的绝对值累加到bx
    inc ax                 ; 负数个数计数器ax加1
L2:                        ; 处理非负数或负数处理完成后执行
    inc si                 ; 索引si加1，指向数组下一个元素
    loop L1                ; cx减1，若不为0则继续循环
    
    ; 显示负数的个数
    mov dl, al             ; al中存放负数的个数（0-10）
    add dl, 30h            ; 转换为ASCII码（0-9对应'0'-'9'）
    mov ah, 02h            ; DOS功能调用：字符输出
    int 21h
    call crlf              ; 调用子程序输出回车换行
    
    ; 显示负数之和（结果为负数，先输出负号）
    mov dl, 2dh            ; 2dh是'-'的ASCII码
    mov ah, 02h            ; 输出负号
    int 21h
    
    ; 将负数绝对值之和（bx中的值）转换为十进制并显示（处理百位、十位、个位）
    ; mov cx, 10000         ; 注释：原计划处理万位，因总和绝对值小于10000，故省略
    ; call dec_div
    ; mov cx, 1000          ; 注释：原计划处理千位，因总和绝对值小于1000，故省略
    ; call dec_div
    mov cx, 100            ; 除数为100，提取百位
    call dec_div
    mov cx, 10             ; 除数为10，提取十位
    call dec_div
    mov cx, 1              ; 除数为1，提取个位
    call dec_div
    
    ; 程序结束，返回DOS
    MOV AH,4CH
    INT 21H
    
; 子程序：输出回车换行
crlf proc near
    mov dl, 13             ; 回车符ASCII码（13）
    mov ah, 02h            ; 输出回车
    int 21h
    mov dl, 10             ; 换行符ASCII码（10）
    mov ah, 02h            ; 输出换行
    int 21h
    ret
crlf endp

; 子程序：将bx中的数除以cx，提取一位十进制数并显示
dec_div proc near
    mov ax, bx            ; 将累加和（bx）移入ax
    mov dx, 0             ; dx清零（扩展被除数为32位：dx:ax）
    div cx                ; ax = 商（当前位的数字），dx = 余数（剩余部分）
    mov bx, dx            ; 保存余数到bx（用于下一次计算）
    mov dl, al            ; 商（当前位数值）存入dl
    add dl, 30h           ; 转换为ASCII码（0-9对应'0'-'9'）
    mov ah, 02h           ; 输出该数字
    int 21h
    ret
dec_div endp

CODES ENDS
    END START

