DATAS SEGMENT
    ; 预设字符串数组：共10个4字符字符串（data/name等），以'$'标记数组逻辑结束（用于对比和显示）
    object db 'data','name','time','file','code','path','user','exit','quit','text','$'
    input_max db 10        ; 输入缓冲区：最大可输入字符数（预留10字节，实际需输入4个字符）
    input_real db ?        ; 实际输入字符数（由DOS 0AH功能调用自动填充，记录输入长度）
    input db 10 dup(?)     ; 存储用户输入的4字符字符串（以ASCII码形式保存）
    output db 100 dup(?)   ; 存储最终输出结果（不包含匹配字符串，含逗号分隔，预留足够空间）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段（未定义具体栈空间，使用系统默认堆栈存储子程序调用上下文）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS指向代码段，DS指向数据段，SS指向堆栈段
START:
    MOV AX,DATAS           ; 数据段基地址送入AX（DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保后续能正确访问数据段中的变量
    lea dx, input_max      ; 取输入缓冲区首地址（input_max）送入dx，为DOS输入功能做准备
    mov ah, 0ah            ; 设置DOS功能调用号为0AH（带缓冲区的键盘输入功能）
    int 21h                ; 执行DOS中断：用户输入的4字符存入input，实际输入长度存入input_real
    call crlf              ; 调用换行子程序，分隔输入操作与输出结果，优化屏幕显示

    ; 初始化寄存器：为字符串对比、删除（不写入输出）、结果拼接做准备
    mov si, 0              ; si=输入字符串（input）的字符索引（0-3，对应4个字符，逐位对比）
    mov bx, 0              ; bx=预设数组（object）的偏移量（每次+4，指向当前待对比的4字符字符串）
    mov cx, 10             ; cx=循环次数（预设数组共10个4字符字符串，需逐个对比处理）
    mov di, 0              ; di=输出缓冲区（output）的地址索引（每次+5，4字符+1分隔符，用于拼接结果）

L1:                        ; 循环入口：逐个对比输入字符串与预设数组中的4字符字符串
    mov al, input[si]      ; 取输入字符串当前索引（si）的字符，存入al（用于对比）
    cmp al, object[si+bx]  ; 对比输入字符与预设字符串当前位置（si+bx）的字符
    jnz next               ; 若字符不匹配，跳至next（将当前预设字符串写入输出缓冲区）
    
    inc si                 ; 字符匹配，si索引+1（准备对比下一个字符）
    cmp si, 4              ; 判断是否已对比完4个字符（si=4表示输入与当前预设字符串全匹配）
    je L4                  ; 若全匹配，跳至L4（不写入输出，实现“删除”效果）
    jmp L1                 ; 未对比完4个字符，继续循环对比

next:                      ; 字符不匹配：将当前预设字符串完整写入输出缓冲区
    mov al, object[bx]     ; 取预设字符串第1个字符（bx偏移位置）
    mov output[di], al     
    mov al, object[bx+1]   ; 取预设字符串第2个字符（bx+1偏移位置）
    mov output[di+1], al 
    mov al, object[bx+2]   ; 取预设字符串第3个字符（bx+2偏移位置）
    mov output[di+2], al 
    mov al, object[bx+3]   ; 取预设字符串第4个字符（bx+3偏移位置）
    mov output[di+3], al     

L2:                        ; 处理输出字符串间的分隔符（逗号）：除最后一个字符串外，均加逗号
    cmp cx, 1              ; 判断是否为预设数组的最后一个字符串（cx=1表示最后一个）
    je L3                  ; 若是最后一个，不加分隔符，跳至L3
    mov output[di+4], ','  ; 不是最后一个，在4字符后加逗号（di+4位置存','，分隔字符串）

L3:                        ; 更新输出缓冲区索引：为下一个字符串（若有）预留位置
    add di, 5              ; di+5（4字符+1分隔符，即使最后一个无分隔符，不影响后续结束符）

L4:                        ; 更新预设数组偏移与输入索引：准备处理下一个预设字符串
    add bx, 4              ; bx+4（指向预设数组下一个4字符字符串，每个字符串占4字节）
    mov si, 0              ; si重置为0（下一轮对比从输入字符串第1个字符开始）
    loop L1                ; cx计数器-1，若cx≠0则继续循环，直至所有预设字符串处理完成

    ; 输出最终结果（不含匹配字符串，以逗号分隔剩余字符串）
    mov output[di], '$'    ; 在输出缓冲区末尾加'$'（DOS 09H功能的字符串结束标志，必须添加）
    lea dx, output         ; 取输出缓冲区首地址送入dx，为DOS显示功能做准备
    mov ah, 09h            ; 设置DOS功能调用号为09H（显示以'$'结尾的字符串）
    int 21h                ; 执行DOS中断，在屏幕上显示删除匹配字符串后的结果
    call crlf              ; 调用换行子程序，保持显示格式整洁

    ; 程序正常结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出并释放资源）
    INT 21H                ; 执行DOS中断，返回DOS环境

; 子程序：crlf - 实现屏幕换行（输出回车符+换行符，规范显示格式）
crlf proc near            ; 定义近过程（仅在当前代码段内调用，节省内存）
    mov dl, 13             ; dl=回车符ASCII码（13），使光标回到当前行开头
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出功能）
    int 21h                ; 执行DOS中断，输出回车符
    mov dl, 10             ; dl=换行符ASCII码（10），使光标下移一行
    mov ah, 02h            ; 再次设置单个字符输出功能
    int 21h                ; 执行DOS中断，输出换行符
    ret                    ; 子程序返回，回到调用处继续执行后续代码
crlf endp                 ; 子程序定义结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签（告诉编译器从这里开始执行）
