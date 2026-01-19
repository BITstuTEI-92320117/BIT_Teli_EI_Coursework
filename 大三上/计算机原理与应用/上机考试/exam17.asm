DATAS SEGMENT
    ; 数据段：未定义具体数据，通过寄存器（AX、BX、DL等）存储临时数据（如最大值、最小值、输入数）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：未定义具体栈空间，使用系统默认堆栈，用于子程序调用时保存寄存器原值（如AX、CX、DX）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS=代码段，DS=数据段，SS=堆栈段
START:
    MOV AX,DATAS           ; 数据段基地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保程序能正确访问数据段（此处无显式数据，主要为规范）
    mov cx, 10             ; 循环计数器CX设为10（需输入10个无符号数，控制输入次数）
   
L1:                        ; 循环入口：逐个输入10个无符号数，并更新最大值、最小值
    call input_dec         ; 调用子程序：从键盘输入十进制数，转换为无符号数存入BX
    cmp cx, 10             ; 判断当前是否为第一个输入的数（初始CX=10，输入第一个数后CX减为9）
    jnz L2                 ; 若不是第一个数，跳至L2（开始比较更新最大/最小值）
    mov al, bl             ; 若是第一个数，将输入数（BL，BX低8位）赋值给AL（初始化最大值）
    mov dl, bl             ; 同时将输入数赋值给DL（初始化最小值）
    jmp L4                 ; 跳至L4，跳过后续比较（第一个数无需比较，直接进入下一次循环）

    ; 比较当前输入数与当前最大值，更新最大值
L2:
    cmp bl, al             ; 比较当前输入数（BL）与当前最大值（AL）
    jbe L3                 ; 若当前数≤最大值，不更新，跳至L3（比较最小值）
    mov al, bl             ; 若当前数>最大值，将当前数赋值给AL（更新最大值）

    ; 比较当前输入数与当前最小值，更新最小值
L3:    
    cmp bl, dl             ; 比较当前输入数（BL）与当前最小值（DL）
    jae L4                 ; 若当前数≥最小值，不更新，跳至L4（结束本次比较）
    mov dl, bl             ; 若当前数<最小值，将当前数赋值给DL（更新最小值）

L4:
    loop L1                ; CX减1，若CX≠0则继续循环，输入下一个数
    
    ; 输出最终结果：先输出最大值，换行后输出最小值
    mov bl, al             ; 将最大值（AL）移入BL，适配binidec子程序的参数要求（处理BX）
    mov bh, 0              ; BX高8位（BH）清零，确保BX为16位无符号数（避免高位干扰）
    call binidec           ; 调用子程序：将BX中的最大值转换为十进制并显示
    mov bl, dl             ; 将最小值（DL）移入BL，适配binidec子程序
    mov bh, 0              ; BX高8位清零
    call binidec           ; 调用子程序：将BX中的最小值转换为十进制并显示
    
    ; 程序结束，返回DOS系统
    MOV AH,4CH
    INT 21H

; 子程序：input_dec - 从键盘输入十进制字符（0-9），转换为无符号数存入BX
input_dec proc near
    push ax                ; 保存主程序中的AX值（避免子程序修改）
    push cx                ; 保存主程序中的CX值
    push dx                ; 保存主程序中的DX值
    mov bx, 0              ; 初始化BX为0，用于存储转换后的十进制数（累加结果）
read_digit:                ; 循环读取单个十进制字符
    mov ah, 1              ; DOS功能调用号1：单个字符输入（输入字符存入AL）
    int 21h                ; 执行输入，读取键盘字符
    
    ; 判断输入字符是否为有效十进制数字（仅接受'0'-'9'）
    cmp al, '0'            ; 比较输入字符与'0'（ASCII码30H）
    jl input_end           ; 若小于'0'（非数字，如回车），结束输入
    cmp al, '9'            ; 比较输入字符与'9'（ASCII码39H）
    jg input_end           ; 若大于'9'（非数字），结束输入
    
    ; 将ASCII字符转换为数值，并拼接成完整十进制数
    sub al, 30h            ; ASCII码转数值（'0'→0，'9'→9）
    mov ah, 0              ; 清空AH，将AL（8位数值）扩展为AX（16位数值，避免后续乘法溢出）
    push ax                ; 保存当前数字（AX），避免被乘法覆盖
    mov ax, bx             ; 将已拼接的数（BX）移入AX，准备进行“乘以10”操作（十进制位左移）
    
    ; 计算：当前累计值 = 累计值×10 + 当前数字（实现十进制数拼接）
    mov cx, 10             ; CX=10，用于乘法运算（实现×10）
    mul cx                 ; AX = AX×10（累计值左移一位十进制，腾出个位）
    mov bx, ax             ; 将乘法结果（AX）存回BX，更新累计值
    pop ax                 ; 恢复当前数字（AX）
    add bx, ax             ; BX = 累计值×10 + 当前数字，完成一次位拼接
    
    jmp read_digit         ; 继续读取下一个十进制字符
input_end:                 ; 输入结束，恢复主程序寄存器
    pop dx                 ; 恢复DX原值
    pop cx                 ; 恢复CX原值
    pop ax                 ; 恢复AX原值
    ret                    ; 返回主程序
input_dec endp

; 子程序：crlf - 输出回车符（13）和换行符（10），实现屏幕换行，分隔输出结果
crlf proc near
    mov ah, 02h            ; DOS功能调用号2：单个字符输出
    mov dl, 13             ; DL=13（回车符ASCII码），使光标回到当前行开头
    int 21h                ; 执行输出，输出回车符
    mov ah, 02h            ; 再次调用字符输出功能
    mov dl, 10             ; DL=10（换行符ASCII码），使光标下移一行
    int 21h                ; 执行输出，输出换行符
    ret                    ; 返回主程序
crlf endp

; 子程序：binidec - 将BX中的无符号数转换为十进制数并显示（处理百位、十位、个位）
binidec proc near    
    push dx                ; 保存主程序中的DX值，避免被子程序修改
    mov cx, 100d           ; CX=100（除数），用于提取十进制数的“百位”
    call dec_div           ; 调用dec_div：计算百位并输出
    mov cx, 10d            ; CX=10（除数），用于提取十进制数的“十位”
    call dec_div           ; 调用dec_div：计算十位并输出
    mov cx, 1d             ; CX=1（除数），用于提取十进制数的“个位”
    call dec_div           ; 调用dec_div：计算个位并输出
    call crlf              ; 输出回车换行，分隔最大值与最小值的显示
    pop dx                 ; 恢复主程序中的DX值
    ret                    ; 返回调用处
binidec endp              ; binidec子程序结束
    
; 子程序：dec_div - 辅助binidec：将BX中的数除以CX，商（对应十进制位）转ASCII输出，余数存回BX
dec_div proc near    
    mov ax, bx             ; AX = BX（将被除数送入AX，准备除法）
    mov dx, 0              ; DX=0（扩展被除数为32位：DX:AX，避免16位除法溢出）
    div cx                 ; 执行除法：AX=商（当前十进制位的数值），DX=余数（剩余部分）
    mov bx, dx             ; 将余数存入BX，用于后续低位（十位、个位）的计算
    mov dl, al             ; DL=商（当前位数值），准备转换为ASCII码
    add dl, 30h            ; 数值转ASCII码（0→'0'，9→'9'，30H为'0'的ASCII码）
    mov ah, 2              ; DOS功能调用号2：单个字符输出
    int 21h                ; 执行输出，显示当前十进制位的字符
    ret                    ; 返回调用处
dec_div endp               ; dec_div子程序结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签

