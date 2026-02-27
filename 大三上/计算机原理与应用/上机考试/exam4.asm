DATAS SEGMENT
    ; 预设目标字符串数组：共10个4字符字符串（data/name等），以'$'结尾标记数组逻辑结束
    object db 'data','name','time','file','code','path','user','exit','quit','text','$'
    input_max db 10        ; 输入缓冲区：最大可输入字符数（预留10字节，实际需输入4字符）
    input_real db ?        ; 实际输入字符数（由DOS 0AH功能调用自动填充）
    input db 10 dup(?)     ; 存储用户输入的4字符字符串（ASCII码形式）
    output db 100 dup(?)   ; 存储最终输出结果（含替换后字符串+分隔符，预留足够空间）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体栈空间，使用系统默认堆栈存储子程序调用上下文）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS=代码段，DS=数据段，SS=堆栈段
START:
    MOV AX,DATAS           ; 数据段地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保正确访问数据段内容
    lea dx, input_max      ; 取输入缓冲区首地址（input_max）送入dx，为DOS输入做准备
    mov ah, 0ah            ; 设置DOS功能调用号为0AH（带缓冲区的键盘输入功能）
    int 21h                ; 执行DOS中断：用户输入的4字符存入input，实际长度存入input_real
    call crlf              ; 调用换行子程序，优化显示格式

    ; 初始化寄存器：为字符串对比、替换、输出拼接做准备
    mov si, 0              ; si=输入字符串（input）的字符索引（0-3，对应4个字符）
    mov bx, 0              ; bx=预设数组（object）的偏移量（每次+4，对应每个4字符字符串）
    mov cx, 10             ; cx=循环次数（预设数组共10个4字符字符串，需逐个处理）
    mov di, 0              ; di=输出缓冲区（output）的地址索引（每次+5，4字符+1分隔符）

L1:                        ; 循环入口：逐个对比输入字符串与预设数组中的每个4字符字符串
    mov al, input[si]      ; 取输入字符串当前索引（si）的字符，存入al
    cmp al, object[si+bx]  ; 对比输入字符与预设字符串当前位置（si+bx）的字符
    jnz next               ; 若字符不匹配，跳至next（当前预设字符串原样存入输出）
    
    inc si                 ; 字符匹配，si索引+1（准备对比下一个字符）
    cmp si, 4              ; 判断是否已对比完4个字符（si=4表示全匹配）
    je disk                ; 若4个字符全匹配，跳至disk（将该字符串替换为disk）
    jmp L1                 ; 未对比完4个字符，继续循环对比

next:                      ; 字符不匹配：将当前预设字符串原样复制到输出缓冲区
    mov al, object[bx]     ; 取预设字符串第1个字符（bx偏移）
    mov output[di], al     
    mov al, object[bx+1]   ; 取预设字符串第2个字符（bx+1偏移）
    mov output[di+1], al 
    mov al, object[bx+2]   ; 取预设字符串第3个字符（bx+2偏移）
    mov output[di+2], al 
    mov al, object[bx+3]   ; 取预设字符串第4个字符（bx+3偏移）
    mov output[di+3], al     
    jmp L2                 ; 复制完成，跳至L2处理分隔符

disk:                      ; 4字符全匹配：将预设字符串替换为"disk"，存入输出缓冲区
    mov output[di], 'd'    ; 输出缓冲区第1位存'd'
    mov output[di+1], 'i'  ; 第2位存'i'
    mov output[di+2], 's'  ; 第3位存's'
    mov output[di+3], 'k'  ; 第4位存'k'

L2:                        ; 处理输出字符串间的分隔符（逗号）
    cmp cx, 1              ; 判断是否为最后一个预设字符串（cx=1表示最后一个）
    je L3                  ; 若是最后一个，不加分隔符，跳至L3
    mov output[di+4], ','  ; 不是最后一个，在4字符后加逗号（第5位存','）

L3:                        ; 更新寄存器，准备处理下一个预设字符串    
    add di, 5              ; di索引+5（输出缓冲区下一个位置：4字符+1分隔符）
    add bx, 4              ; bx偏移+4（指向预设数组下一个4字符字符串）
    mov si, 0              ; si重置为0（下一轮对比从输入字符串第1个字符开始）
    loop L1                ; cx计数器-1，若cx≠0则继续循环处理下一个预设字符串

    ; 输出最终结果（含替换后的字符串，以逗号分隔）
    mov output[di], '$'    ; 在输出缓冲区末尾加'$'（DOS 09H功能的字符串结束标志）
    lea dx, output         ; 取输出缓冲区首地址送入dx，为DOS显示做准备
    mov ah, 09h            ; 设置DOS功能调用号为09H（显示以'$'结尾的字符串）
    int 21h                ; 执行DOS中断，在屏幕上显示结果
    call crlf              ; 调用换行子程序，优化显示格式

    ; 程序正常结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出并释放资源）
    INT 21H                ; 执行DOS中断，返回DOS环境

; 子程序：crlf - 实现屏幕换行（输出回车符+换行符）
crlf proc near            ; 定义近过程（仅在当前代码段内调用）
    mov dl, 13             ; dl=回车符ASCII码（13）
    mov ah, 02h            ; DOS功能调用号02H（单个字符输出）
    int 21h                ; 输出回车符（光标回到当前行开头）
    mov dl, 10             ; dl=换行符ASCII码（10）
    mov ah, 02h            ; 再次调用单个字符输出功能
    int 21h                ; 输出换行符（光标下移一行）
    ret                    ; 子程序返回，回到调用处继续执行
crlf endp                 ; 子程序定义结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签

