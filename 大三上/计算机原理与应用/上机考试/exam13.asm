DATAS SEGMENT
    ; 数据段：无需显式定义数据存储区，通过寄存器（AX、BX等）存储临时数据（累加和、输入值）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：未定义具体栈空间，使用系统默认堆栈，用于子程序调用时保存寄存器原值（如AX、CX）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS=代码段，DS=数据段，SS=堆栈段
START:
    MOV AX,DATAS           ; 将数据段基地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保程序访问数据段规范
    mov ax, 0              ; AX初始化为0，用于存储6个十六进制数的累加和
    mov cx, 6              ; CX=6（循环计数器，控制输入6个十六进制数）
L:                        ; 循环入口：输入6个十六进制数并累加
    call hexibin           ; 调用子程序：从键盘输入一个十六进制数，转换为二进制数存入BX
    add ax, bx             ; 将当前输入的数（BX）累加到总和（AX）
    loop L                 ; CX减1，若CX≠0则继续循环输入下一个数
    
    ; 显示累加和（十六进制格式，后缀加'h'）
    mov bx, ax             ; 将总和（AX）移入BX，适配bin_to_hex子程序的处理对象
    call bin_to_hex        ; 调用子程序：将BX中的二进制数转换为十六进制字符串并显示
    mov dl, 'h'            ; DL='h'（十六进制数后缀，提升显示可读性）
    mov ah, 02h            ; DOS功能调用号2：单个字符输出
    int 21h                ; 执行输出，显示'h'
    
    ; 程序结束，返回DOS系统
    MOV AH,4CH
    INT 21H

; 子程序：crlf - 输出回车符（13）和换行符（10），实现屏幕换行
crlf proc near      
    mov ah, 2              ; DOS功能号2：单个字符输出
    mov dl, 13             ; DL=13（回车符ASCII码，使光标回到当前行开头）
    int 21h                ; 执行DOS中断，输出回车符
    mov dl, 10             ; DL=10（换行符ASCII码，使光标下移一行）
    int 21h                ; 执行DOS中断，输出换行符
    ret                    ; 子程序返回，回到调用处
crlf endp                  ; crlf子程序结束    

; 子程序：hexibin - 从键盘读取十六进制字符（0-9、A-F、a-f），转换为16位二进制数存入BX
hexibin proc near    
    push ax                ; 保存主程序中的AX值（避免子程序修改）
    push cx                ; 保存主程序中的CX值
    mov bx, 0              ; 初始化BX为0，用于存储转换后的十六进制数（二进制形式）
newchar:                   ; 循环标签：持续读取单个十六进制字符
    mov ah, 1              ; DOS功能号1：单个字符输入（输入字符存入AL）
    int 21h                ; 执行DOS中断，读取键盘输入
    
    sub al, 30h            ; 将输入字符的ASCII码转为数值（0-9的ASCII码减30H得对应数值）
    jl exit                ; 若数值<0（非数字/字母字符，如回车），跳至exit结束转换
    cmp al, 10             ; 比较数值与10（区分数字0-9和字母A-F/a-f）
    jl add_to              ; 若数值<10（是数字0-9），跳至add_to处理
    sub al, 27h            ; 字母A-F/a-f转换：A(41H)减30H得11H，再减27H得0AH（对应10）；a同理
    cmp al, 0ah            ; 比较转换后数值与10（0AH）
    jl exit                ; 若<10（非法字符），跳至exit
    cmp al, 10h            ; 比较转换后数值与16（10H）
    jge exit               ; 若≥16（非法字符），跳至exit
    
add_to:                    ; 处理有效十六进制位，拼接成完整数值
    mov cl, 4              ; CL=4，用于移位（左移4位等价于乘以16，腾出低4位）
    shl bx, cl             ; BX左移4位，为新输入的4位十六进制数预留位置
    mov ah, 0              ; AH清零，将AL（8位数值）扩展为AX（16位，避免拼接时溢出）
    add bx, ax             ; BX = 原BX×16 + 当前输入的4位数值（完成一位拼接）
    jmp newchar            ; 跳转至newchar，继续读取下一个十六进制字符
    
exit:                      ; 转换结束，恢复寄存器并换行
    call crlf              ; 调用crlf，输入完成后换行
    pop cx                 ; 恢复主程序中的CX值
    pop ax                 ; 恢复主程序中的AX值
    ret                    ; 子程序返回，BX中存储转换后的二进制数
hexibin endp               ; hexibin子程序结束

; 子程序：bin_to_hex - 将BX中的16位二进制数转换为4位十六进制字符串并显示
bin_to_hex proc near
    mov ch, 4              ; CH=4（16位二进制数对应4个十六进制位，循环4次）
rotate:                    ; 循环标签：逐位处理十六进制位（从高位到低位）
    mov cl, 4              ; CL=4，移位量为4（每次处理4位）
    rol bx, cl             ; BX循环左移4位，将当前最高4位移至低4位（便于提取）
    mov al, bl             ; 取BX低8位存入AL（仅关注低4位）
    and al, 0fh            ; 屏蔽AL高4位，仅保留低4位（当前待处理的十六进制位）
    add al, 30h            ; 将4位数值转为ASCII码（0-9对应'0'-'9'）
    cmp al, 3ah            ; 比较ASCII码与3AH（'9'的ASCII码是39H，3AH为'9'的下一个字符）
    jl printit             ; 若<3AH（是'0'-'9'），跳至printit直接输出
    add al, 27h             ; 若≥3AH（是10-15），加7H转为'A'-'F'的ASCII码（3AH+7H=41H='A'）
    
printit:                   ; 输出当前十六进制字符
    mov dl, al             ; 将待输出的ASCII码存入DL
    mov ah, 2              ; DOS功能号2：单个字符输出
    int 21h                ; 执行DOS中断，输出当前十六进制字符
    dec ch                 ; 计数器CH减1（处理完一位）
    jnz rotate             ; 若CH≠0，跳至rotate继续处理下一位
    ret                    ; 子程序返回
bin_to_hex endp
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签
