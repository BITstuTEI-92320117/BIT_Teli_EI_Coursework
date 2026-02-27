DATAS SEGMENT
    ch_num_max db 100      ; 输入缓冲区：最大可输入字符数（100个）
    ch_num_real db ?       ; 实际输入字符数（由DOS 0AH功能调用自动填充）
    cha db 100 dup(?)      ; 存储输入的字符序列（ASCII码形式）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体内容，使用默认堆栈）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           ; 初始化数据段寄存器
    MOV DS,AX
    lea dx, ch_num_max     ; 取输入缓冲区首地址到dx
    mov ah, 0ah            ; DOS功能调用：带缓冲区的键盘输入（0AH）
    int 21h                ; 执行输入，输入字符存入cha缓冲区，实际长度存入ch_num_real
    
    ; 输入后换行，准备显示统计结果
    mov dl, 13             ; 回车符ASCII码（13）
    mov ah, 02h            ; DOS功能调用：字符输出（02H）
    int 21h
    mov dl, 10             ; 换行符ASCII码（10）
    mov ah, 02h
    int 21h
    
    ; 第一部分：统计字母（大写A-Z或小写a-z）的数量
    mov cl, byte ptr ch_num_real  ; 循环次数=实际输入字符数（存入cx）
    mov ch, 0                     ; cx高8位清零，cx=实际字符数
    mov si, 0                     ; 变址寄存器si初始化（指向字符缓冲区起始位置）
    mov bx, 0                     ; bx用作字母计数器，初始化为0
L11:
    cmp cha[si], 41h              ; 比较当前字符与'A'（ASCII 41H）
    jl L13                        ; 若小于'A'，不是字母，跳至L13
    cmp cha[si], 7ah              ; 比较当前字符与'z'（ASCII 7ah）
    jg L13                        ; 若大于'z'，不是字母，跳至L13
    cmp cha[si], 5ah              ; 比较当前字符与'Z'（ASCII 5ah）
    jle L12                        ; 若小于等于'Z'，是大写字母，跳至L12（计数）
    cmp cha[si], 61h              ; 比较当前字符与'a'（ASCII 61h）
    jl L13                        ; 若在'Z'和'a'之间（非字母），跳至L13
L12:
    inc bx                         ; 字母计数器加1
L13:
    inc si                         ; 移动到下一个字符
    loop L11                       ; 循环处理所有字符，直到cx为0
    call binidec                   ; 调用子程序，将bx中的字母计数以十进制显示
    
    ; 第二部分：统计数字（0-9）的数量
    mov cl, byte ptr ch_num_real  ; 重置循环次数=实际输入字符数
    mov ch, 0                     
    mov si, 0                     ; 重置变址寄存器
    mov bx, 0                     ; bx用作数字计数器，初始化为0
L21:
    cmp cha[si], 30h              ; 比较当前字符与'0'（ASCII 30h）
    jl L22                        ; 若小于'0'，不是数字，跳至L22
    cmp cha[si], 3ah              ; 比较当前字符与':'（ASCII 3ah，'9'的下一个字符）
    jge L22                       ; 若大于等于':'，不是数字，跳至L22
    inc bx                         ; 数字计数器加1
L22:
    inc si                         ; 移动到下一个字符
    loop L21                       ; 循环处理所有字符
    call binidec                   ; 调用子程序，将bx中的数字计数以十进制显示
    
    ; 第三部分：统计空格（空格符）的数量
    mov cl, byte ptr ch_num_real  ; 重置循环次数=实际输入字符数
    mov ch, 0                     
    mov si, 0                     ; 重置变址寄存器
    mov bx, 0                     ; bx用作空格计数器，初始化为0
L31:
    cmp cha[si], 20h              ; 比较当前字符与空格（ASCII 20h）
    jnz L32                        ; 若不是空格，跳至L32
    inc bx                         ; 空格计数器加1
L32:
    inc si                         ; 移动到下一个字符
    loop L31                       ; 循环处理所有字符
    call binidec                   ; 调用子程序，将bx中的空格计数以十进制显示
    
    ; 程序结束，返回DOS
    MOV AH,4CH
    INT 21H

; 子程序：将bx中的二进制数转换为十进制并显示（三位数格式）
binidec proc near
    mov cx, 100           ; 除数=100（用于提取百位）
    call dec_div          ; 调用除法子程序，显示百位
    mov cx, 10            ; 除数=10（用于提取十位）
    call dec_div          ; 调用除法子程序，显示十位
    mov cx, 1             ; 除数=1（用于提取个位）
    call dec_div          ; 调用除法子程序，显示个位
    ; 显示后换行
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    ret
binidec endp

; 子程序：除法处理，提取一位十进制数并显示
dec_div proc near
    mov ax, bx            ; 将计数器值（bx）移入ax
    mov dx, 0             ; dx清零（扩展被除数为32位：dx:ax）
    div cx                ; ax = dx:ax / cx（商），dx = 余数
    mov bx, dx            ; 保存余数到bx（用于下一次计算）
    mov dl, al            ; 商（当前位数值）存入dl
    add dl, 30h           ; 转换为ASCII码（0-9对应'0'-'9'）
    mov ah, 02h           ; 显示该数字
    int 21h
    ret
dec_div endp

CODES ENDS
    END START
