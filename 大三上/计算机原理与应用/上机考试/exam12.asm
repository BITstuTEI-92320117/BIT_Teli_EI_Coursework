DATAS SEGMENT
    max_num1 db 9          ; 第一个数输入缓冲区：最大长度9（适配8位十进制数+1字节预留，满足输入需求）
    real_num1 db ?         ; 第一个数实际输入字符数（由DOS 0AH功能调用自动填充，记录有效长度）
    num1 db 9 dup(?)       ; 存储第一个输入数的十进制数字符（ASCII码形式，如输入"35789418"对应ASCII存于此）
    max_num2 db 9          ; 第二个数输入缓冲区：最大长度9（同第一个数，适配8位十进制数输入）
    real_num2 db ?         ; 第二个数实际输入字符数（DOS 0AH自动填充）
    num2 db 9 dup(?)       ; 存储第二个输入数的十进制数字符（ASCII码形式，如输入"46531425"对应ASCII存于此）
    result db 20 dup(?)    ; 存储两数之和的结果（预留20字节足够空间，避免溢出，以ASCII码形式保存）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：未定义具体栈空间，使用系统默认堆栈（用于子程序调用时临时保存寄存器值，此处crlf子程序未用到栈，但预留规范）
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS  ; 关联段寄存器：CS=代码段（存指令），DS=数据段（存数组/变量），SS=堆栈段
START:
    MOV AX,DATAS           ; 将数据段基地址送入AX（因DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保程序能正确访问数据段中的缓冲区和变量
    
    ; 输入第一个十进制数（35789418）
    lea dx, max_num1       ; 取第一个数输入缓冲区首地址（max_num1）送入dx，为DOS输入功能传参
    mov ah, 0ah            ; 设置DOS功能调用号为0AH（带缓冲区的键盘输入功能，支持指定最大输入长度）
    int 21h                ; 执行DOS中断：用户输入的第一个数存入num1，实际输入长度存入real_num1
    call crlf              ; 调用换行子程序，分隔第一个数输入与第二个数输入，优化显示
    
    ; 输入第二个十进制数（46531425）
    lea dx, max_num2       ; 取第二个数输入缓冲区首地址（max_num2）送入dx
    mov ah, 0ah            ; 再次设置DOS 0AH输入功能
    int 21h                ; 执行DOS中断：用户输入的第二个数存入num2，实际输入长度存入real_num2
    call crlf              ; 调用换行子程序，分隔输入操作与结果显示

    ; 初始化寄存器：为8位十进制数逐位相加（从最低位到最高位）做准备
    mov si, 7              ; si=7（num1/num2存储8位数字，索引0-7，7对应数字最低位，从低位开始累加符合计算逻辑）
    mov di, 0              ; di=0（结果缓冲区辅助索引，暂用，实际结果位置与输入数索引同步）
    mov dx, 0              ; dx的低8位dl用于存储每一位相加的进位（初始为0，无进位）
    mov cx, 8              ; cx=8（循环8次，对应8位十进制数，逐位处理所有数字）

L:                        ; 循环入口：逐位计算两数之和（含进位传递）
    mov bl, num1[si]       ; 取第一个数当前位（si位置）的ASCII码，存入bl（临时存储）
    sub bl, 30h            ; 将ASCII码转为十进制数值（如'3'的ASCII码33H减30H得数值3）
    add bl, num2[si]       ; 加上第二个数当前位（si位置）的ASCII码（此时bl=第一个数数值+第二个数ASCII码）
    sub bl, 30h            ; 再次减30H，将第二个数的ASCII码转为数值（此时bl=两数当前位数值之和）
    add bl, dl             ; 加上上一位相加产生的进位（dl初始为0，后续为0或1）
    mov dl, 0              ; 重置进位为0（先假设当前位无进位，后续判断后更新）
    
    cmp bl, 10             ; 判断当前位总和（含进位）是否≥10（是否产生新进位）
    jl lowten              ; 若总和<10，无进位，跳至lowten处理当前位结果
    sub bl, 10             ; 若总和≥10，当前位数值=总和-10（保留个位）
    mov dl, 1              ; 标记新进位为1（传递到下一位相加）

lowten:                   ; 处理无进位的当前位结果（或减10后的个位结果）
    add bl, 30h            ; 将当前位数值转为ASCII码（如数值5加30H得'5'的ASCII码35H）
    mov result[si], bl     ; 将转换后的ASCII码存入result对应位置（与输入数的位位置同步，si不变）
    inc di                 ; 结果缓冲区辅助索引di加1（仅计数，无实际位置关联）
    dec si                 ; si减1（移动到上一位，即更高位，准备处理下一位相加）
    loop L                 ; cx减1，若cx≠0则继续循环，直至8位数字全部处理完成

    ; 显示两数之和的最终结果
    lea dx, result         ; 取结果缓冲区首地址送入dx，为DOS显示功能传参
    mov result[di], '$'    ; 在结果末尾添加'$'（DOS 09H功能的字符串结束标志，必须添加否则显示异常）
    mov ah, 09h            ; 设置DOS功能调用号为09H（显示以'$'结尾的字符串功能）
    int 21h                ; 执行DOS中断，在屏幕上显示两数之和的结果

    ; 程序正常结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出并释放资源，标准结束方式）
    INT 21H                ; 执行DOS中断，返回DOS环境

; 子程序：crlf - 实现屏幕换行（输出回车符+换行符，规范显示格式，避免内容重叠）
crlf proc near            ; 定义近过程（仅在当前代码段内调用，节省内存）
    mov dl, 13             ; dl=13（回车符ASCII码），使光标回到当前行开头
    mov ah, 02h            ; 设置DOS功能调用号为02H（单个字符输出功能）
    int 21h                ; 执行DOS中断，输出回车符
    mov dl, 10             ; dl=10（换行符ASCII码），使光标下移一行
    mov ah, 02h            ; 再次设置单个字符输出功能
    int 21h                ; 执行DOS中断，输出换行符
    ret                    ; 子程序返回，回到调用处继续执行后续代码
crlf endp                 ; 子程序定义结束
CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签（编译器从该标签开始执行指令）
