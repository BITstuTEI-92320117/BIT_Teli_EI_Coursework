DATAS SEGMENT
    input_max db 255       ; 输入缓冲区：最大可输入字符数（255个）
    input_real db ?        ; 实际输入字符数（由DOS 0AH功能调用自动填充）
    input db 255 dup(?)    ; 存储输入的原始字符串（ASCII码形式）
    output db 511 dup(?)   ; 存储处理后的字符串（预留足够空间，因可能替换字符导致长度增加）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体内容，使用默认堆栈）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           ; 初始化数据段寄存器，使DS指向数据段
    MOV DS,AX
    lea dx, input_max      ; 取输入缓冲区首地址到dx
    mov ah, 0ah            ; DOS功能调用：带缓冲区的键盘输入（0AH）
    int 21h                ; 执行输入，输入字符串存入input，实际长度存入input_real
    call crlf              ; 调用子程序输出回车换行，分隔输入和输出结果
    
    lea si, input          ; si指向输入字符串input的起始位置（源地址指针）
    lea di, output         ; di指向输出字符串output的起始位置（目标地址指针）
    mov cl, input_real     ; 循环次数=实际输入字符数（存入cx，ch默认0）
L1:                        ; 循环处理输入字符串中的每个字符
    mov al, [si]           ; 将当前输入字符（si指向）存入al
    cmp al, 41h            ; 比较当前字符与'A'（ASCII码41H）
    jnz not_a              ; 若不是'A'，跳至not_a（直接复制字符）
    
    ; 若当前字符是'A'，替换为"CC"
    mov byte ptr [di], 43h ; 在输出缓冲区存入'C'（ASCII码43H）
    inc di                 ; 目标指针di后移一位（准备存下一个'C'）
    mov byte ptr [di], 43h ; 再存入一个'C'
    inc di                 ; 目标指针di再后移一位
    jmp L2                 ; 跳至L2，处理下一个输入字符

not_a:                     ; 处理非'A'字符（直接复制到输出缓冲区）
    mov [di], al           ; 将当前输入字符复制到输出缓冲区
    inc di                 ; 目标指针di后移一位
L2:
    inc si                 ; 源指针si后移一位（指向 next输入字符）
    loop L1                ; cx减1，若不为0则继续循环处理下一个字符
    
    ; 输出处理后的字符串
    lea dx, output         ; dx指向输出字符串output的起始位置
    mov byte ptr [di], '$' ; 在输出字符串末尾添加'$'（DOS 09H功能的结束标志）
    mov ah, 09h            ; DOS功能调用：显示字符串（09H）
    int 21h                ; 执行显示，输出处理后的结果
    call crlf              ; 输出回车换行，美化显示
    
    ; 程序结束，返回DOS
    MOV AH,4CH
    INT 21H

; 子程序：crlf - 输出回车（13）和换行（10），实现换行功能
crlf proc near
    mov dl, 13             ; dl=13（回车符ASCII码）
    mov ah, 02h            ; DOS功能调用：字符输出（02H）
    int 21h                ; 输出回车
    mov dl, 10             ; dl=10（换行符ASCII码）
    mov ah, 02h            ; 再次调用字符输出功能
    int 21h                ; 输出换行
    ret                    ; 返回主程序
crlf endp
CODES ENDS
    END START
