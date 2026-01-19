DATAS SEGMENT    
DATAS ENDS

STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           
    MOV DS,AX                
L:         ; 主循环体
    call input_dec
    call bin_to_hex 
    call crlf      
    jmp L  ; 循环实现连续输入

; 回车换行子程序
crlf proc near
    mov ah, 2       
    mov dl, 13      
    int 21h
    mov dl, 10      
    int 21h
    ret
crlf endp

; 十进制转二进制子程序
input_dec proc near
    mov bx, 0       
read_digit:
    mov ah, 1       ; 字符输入
    int 21h         
    
    cmp al, 27      
    je exit         ; 输入为ESC，跳转至程序结束
    
    cmp al, '0'     ; 检查是否为'0'~'9'，不符合条件结束输入
    jl input_end    
    cmp al, '9'
    jg input_end    
    
    sub al, 30h     ; 将ASCII码转换为数值（0-9）
    mov ah, 0       
    push ax        
    mov ax, bx     
    
    ; 计算数值
    mov cx, 10    
    mul cx       
    mov bx, ax     
    pop ax          
    add bx, ax         
    jmp read_digit  ; 继续读取下一位数字
input_end:
    ret
input_dec endp


; 二进制转十六进制子程序
bin_to_hex proc near
    mov ch, 4       ; 设置循环4次
rotate:
    mov cl, 4       ; 循环移位处理
    rol bx, cl      
    mov al, bl     
    and al, 0fh    
    add al, 30h     
    cmp al, 3ah    
    jl printit      
    add al, 7h      
printit:
    mov dl, al      ; 输出对应字符
    mov ah, 2      
    int 21h       
    dec ch         
    jnz rotate      
    ret
bin_to_hex endp

; 程序结束处理
exit:
    mov ah, 4ch    
    int 21h        
CODES ENDS
    END START       
