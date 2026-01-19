DATAS SEGMENT
    ; 定义包含10个带符号字（16位）的数组num，存储示例数据（有正数也有负数）
    num dw -123, 456, -78, 90, -1, 2, -3, 4, -5, 6  ; 10个带符号字（示例数据）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：未定义具体栈空间，使用系统默认堆栈（用于子程序调用时保存寄存器值，如push cx）
STACKS ENDS

CODES SEGMENT
    ; 关联段寄存器：CS指向代码段（存放指令），DS指向数据段（存放数组num），SS指向堆栈段
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           ; 将数据段基地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保程序能正确访问数组num
    
    ; 初始化寄存器：准备遍历数组并处理元素
    mov si, 0              ; si = 0：数组num的索引（字类型元素占2字节，后续每次+2）
    mov cx, 10             ; cx = 10：循环计数器，控制遍历数组的10个元素
L1:                        ; 循环入口：逐个处理数组中的元素
    mov bx, num[si]        ; 将数组当前元素（num[si]）存入bx（暂存待处理元素）
    cmp bx, 0              ; 比较当前元素与0（判断是否为负数）
    jge L2                 ; 若当前元素≥0（非负数），跳至L2（不处理，直接继续循环）
    
    ; 若为负数：取绝对值并输出
    neg bx                 ; 对负数取绝对值（neg指令：bx = -bx，补码取反加1实现）
    call hexibin           ; 调用子程序：将bx中的绝对值以十进制形式输出
    call crlf              ; 调用子程序：输出回车换行（每个负数的绝对值单独占一行）

L2:                        ; 处理非负数或负数输出完成后：更新索引并继续循环
    add si, 2              ; si + 2（移动到数组下一个元素，因元素为字类型占2字节）
    loop L1                ; 循环计数器cx减1，若cx≠0则继续处理下一个元素

    ; 程序结束：退出并返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序正常退出，释放资源）
    INT 21H                ; 执行DOS中断：返回DOS环境

; 子程序：hexibin - 将bx中的无符号数（绝对值）转换为十进制数并输出（处理万位到个位）
hexibin proc near
    push cx                ; 保存主程序中的cx值（避免子程序修改外层循环计数器）
    mov cx, 10000          ; 除数=10000，用于提取万位数字
    call dec_div           ; 调用dec_div：输出万位
    mov cx, 1000           ; 除数=1000，用于提取千位数字
    call dec_div           ; 调用dec_div：输出千位
    mov cx, 100            ; 除数=100，用于提取百位数字
    call dec_div           ; 调用dec_div：输出百位
    mov cx, 10             ; 除数=10，用于提取十位数字
    call dec_div           ; 调用dec_div：输出十位
    mov cx, 1              ; 除数=1，用于提取个位数字
    call dec_div           ; 调用dec_div：输出个位
    pop cx                 ; 恢复主程序中的cx值
    ret                    ; 子程序返回
hexibin endp

; 子程序：dec_div - 执行除法提取一位十进制数字，并转换为ASCII码输出
dec_div proc near
    mov ax, bx             ; 将待处理数（bx）送入ax（作为被除数）
    mov dx, 0              ; dx清零（扩展被除数为32位：dx:ax，避免除法溢出）
    div cx                 ; 除法运算：ax = 商（当前位数字），dx = 余数（剩余值）
    mov bx, dx             ; 余数存入bx（用于下一位数字的计算）
    mov dl, al             ; 商（当前位数字）送入dl（用于输出）
    add dl, 30h            ; 数字转换为ASCII码（0→'0'，9→'9'）
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出）
    int 21h                ; 执行DOS中断：输出当前位数字
    ret                    ; 子程序返回
dec_div endp

; 子程序：crlf - 输出回车符（13）和换行符（10），实现换行功能
crlf proc near
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出）
    mov dl, 13             ; dl = 13（回车符ASCII码）：使光标回到当前行开头
    int 21h                ; 输出回车符
    mov ah, 02h            ; 再次设置单个字符输出功能
    mov dl, 10             ; dl = 10（换行符ASCII码）：使光标下移一行
    int 21h                ; 输出换行符
    ret                    ; 子程序返回
crlf endp

CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签（编译器从这里开始执行）
