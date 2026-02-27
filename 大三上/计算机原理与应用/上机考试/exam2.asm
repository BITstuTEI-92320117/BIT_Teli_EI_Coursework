DATAS SEGMENT
    input_max db 255       ; 输入缓冲区：最大可输入字符数（255个，满足长字符串需求）
    input_real db ?        ; 实际输入字符数（由DOS 0AH功能调用自动填充，记录有效字符长度）
    input db 255 dup(?)    ; 存储用户输入的原始字符串（以ASCII码形式保存）
    output db 511 dup(?)   ; 存储处理后的字符串（预留足够空间，与输入长度匹配）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体栈空间，使用系统默认堆栈存储子程序调用上下文）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器与对应段
START:
    MOV AX,DATAS           ; 将数据段地址送入AX（因DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，使其指向DATAS段
    lea dx, input_max      ; 取输入缓冲区首地址（input_max）送入dx，为DOS输入做准备
    mov ah, 0ah            ; 设置DOS功能调用号为0AH（带缓冲区的键盘输入功能）
    int 21h                ; 执行DOS中断，用户输入的字符串存入input，实际长度存入input_real
    call crlf              ; 调用换行子程序，分隔输入操作与输出结果，优化显示效果
    
    ; 初始化循环参数与指针，准备处理字符串
    mov cl, input_real     ; 循环计数器CX的低8位（CL）设为实际输入字符数，控制循环次数
    mov ch, 0              ; CX的高8位（CH）清零，确保CX整体为实际字符数（无符号数）
    lea si, input          ; 源变址寄存器SI指向输入字符串（input）的起始位置，用于读取原始字符
    lea di, output         ; 目标变址寄存器DI指向输出字符串（output）的起始位置，用于存储处理后字符
L:                        ; 循环入口：逐字符处理输入字符串
    mov bl, [si]           ; 将SI指向的当前原始字符送入BL（临时存储，避免直接修改内存）
    cmp bl, 41h            ; 比较当前字符与大写字母'A'（ASCII码41H）
    jl not_b               ; 若字符ASCII码小于41H（不是大写字母），跳至not_b直接复制
    cmp bl, 5ah            ; 比较当前字符与大写字母'Z'（ASCII码5AH）
    jg not_b               ; 若字符ASCII码大于5AH（不是大写字母），跳至not_b直接复制
    add bl, 20h            ; 若为大写字母，加20H转换为对应小写字母（大写与小写ASCII码差值为20H）
not_b:                    ; 非大写字母处理：直接复制字符到输出缓冲区
    mov [di], bl           ; 将处理后的字符（或原始非大写字符）存入DI指向的输出缓冲区
    inc si                 ; SI指针后移1位，指向输入字符串的下一个字符
    inc di                 ; DI指针后移1位，为存储下一个处理后字符预留位置
    loop L                 ; CX计数器减1，若CX≠0则继续循环，直至所有字符处理完成
    
    ; 输出处理后的字符串（小写转换完成的结果）
    lea dx, output         ; 将输出字符串的起始地址送入DX，为DOS显示做准备
    mov byte ptr [di], '$' ; 在输出字符串末尾添加'$'（DOS 09H功能的字符串结束标志，必不可少）
    mov ah, 09h            ; 设置DOS功能调用号为09H（显示以'$'结尾的字符串功能）
    int 21h                ; 执行DOS中断，在屏幕上显示处理后的字符串
    
    ; 程序正常结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出功能）
    INT 21H                ; 执行DOS中断，释放资源并返回DOS

; 子程序：crlf - 实现屏幕换行（输出回车符+换行符）
crlf proc near            ; 定义近过程（子程序）crlf，仅在当前代码段内调用
    mov dl, 13             ; 将回车符ASCII码（13）送入DL（DOS字符输出的内容寄存器）
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出功能）
    int 21h                ; 执行DOS中断，输出回车符（光标回到当前行开头）
    mov dl, 10             ; 将换行符ASCII码（10）送入DL
    mov ah, 02h            ; 再次设置单个字符输出功能
    int 21h                ; 执行DOS中断，输出换行符（光标下移一行）
    ret                    ; 子程序返回，回到调用处继续执行
crlf endp                 ; 子程序定义结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签
