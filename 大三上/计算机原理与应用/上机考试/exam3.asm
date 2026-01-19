DATAS SEGMENT
    input_max db 255       ; 输入缓冲区：最大可输入字符数（255个，满足长字符串需求）
    input_real db ?        ; 实际输入字符数（由DOS 0AH功能调用自动填充，记录有效字符长度）
    input db 255 dup(?)    ; 存储用户输入的原始字符串（以ASCII码形式保存）
    output db 511 dup(?)   ; 存储删除字母后的结果字符串（预留足够空间，与输入长度匹配）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体栈空间，使用系统默认堆栈存储子程序调用上下文）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS指向代码段，DS指向数据段，SS指向堆栈段
START:
    MOV AX,DATAS           ; 将数据段基地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保后续能正确访问数据段内容
    lea dx, input_max      ; 取输入缓冲区首地址（input_max）送入dx，为DOS输入功能做准备
    mov ah, 0ah            ; 设置DOS功能调用号为0AH（带缓冲区的键盘输入功能）
    int 21h                ; 执行DOS中断：用户输入的字符串存入input，实际长度存入input_real
    call crlf              ; 调用换行子程序，分隔输入操作与输出结果，优化屏幕显示

    ; 初始化指针与计数器，准备逐字符处理字符串
    lea si, input          ; 源变址寄存器SI指向输入字符串（input）起始位置，用于读取原始字符
    lea di, output         ; 目标变址寄存器DI指向输出字符串（output）起始位置，用于存储结果字符
    mov cl, input_real     ; 循环计数器CX的低8位（CL）设为实际输入字符数，控制处理次数
    mov ch, 0              ; CX的高8位（CH）清零，确保CX整体为无符号的实际字符数

L:                        ; 循环入口：逐字符判断是否为英文字母，决定保留或删除
    mov bl, [si]           ; 将SI指向的当前原始字符送入BL（临时存储，避免直接修改内存）
    
    ; 多条件判断：筛选出英文字母（大写A-Z：41H-5AH；小写a-z：61H-7AH）
    cmp bl, 41h            ; 比较当前字符与大写字母'A'（ASCII码41H）
    jl copy                ; 若字符ASCII码＜41H（不是字母），跳至copy保留该字符
    cmp bl, 5ah            ; 比较当前字符与大写字母'Z'（ASCII码5AH）
    jle delete             ; 若字符ASCII码≤5AH（是大写字母），跳至delete删除该字符
    cmp bl, 61h            ; 比较当前字符与小写字母'a'（ASCII码61H）
    jl copy                ; 若字符ASCII码在5AH-61H之间（不是字母），跳至copy保留该字符
    cmp bl, 7ah            ; 比较当前字符与小写字母'z'（ASCII码7AH）
    jle delete             ; 若字符ASCII码≤7AH（是小写字母），跳至delete删除该字符

copy:                     ; 非字母字符处理：保留字符到输出缓冲区
    mov [di], bl           ; 将当前非字母字符复制到DI指向的输出缓冲区
    inc di                 ; 目标指针DI后移1位，为存储下一个保留字符预留位置
delete:                   ; 字母字符处理：不保留，直接跳过
    inc si                 ; 源指针SI后移1位，指向输入字符串的下一个字符
    loop L                 ; CX计数器减1，若CX≠0则继续循环，直至所有字符处理完成

    ; 输出删除字母后的结果字符串
    lea dx, output         ; 将输出字符串起始地址送入dx，为DOS显示功能做准备
    mov byte ptr [di], '$' ; 在输出字符串末尾添加'$'（DOS 09H功能的字符串结束标志，必须添加）
    mov ah, 09h            ; 设置DOS功能调用号为09H（显示以'$'结尾的字符串功能）
    int 21h                ; 执行DOS中断，在屏幕上显示删除字母后的结果
    call crlf              ; 调用换行子程序，使后续内容（若有）换行显示，保持格式整洁

    ; 程序正常结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出并释放资源功能）
    INT 21H                ; 执行DOS中断，返回DOS环境

; 子程序：crlf - 实现屏幕换行（输出回车符+换行符，规范显示格式）
crlf proc near            ; 定义近过程（仅在当前代码段内调用）
    mov dl, 13             ; 将回车符ASCII码（13）送入DL（DOS字符输出的内容寄存器）
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出功能）
    int 21h                ; 执行DOS中断，输出回车符（光标回到当前行开头）
    mov dl, 10             ; 将换行符ASCII码（10）送入DL
    mov ah, 02h            ; 再次设置单个字符输出功能
    int 21h                ; 执行DOS中断，输出换行符（光标下移一行）
    ret                    ; 子程序返回，回到调用处继续执行后续代码
crlf endp                 ; 子程序定义结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签
