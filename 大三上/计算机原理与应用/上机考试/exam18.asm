DATAS SEGMENT
    ; 定义有符号字类型数组num，包含5个有效元素，以0作为数组结束标志（0不参与计算）
    num dw 15, -32, -47, 18, 29, 0  ; 示例数组：元素为有符号整数，0用于标记数组结束
    max dw ?                         ; 用于存储数组中的最大值（有符号字类型）
    min dw ?                         ; 用于存储数组中的最小值（有符号字类型）
    ave dw ?                         ; 用于存储数组元素的平均值（有符号字类型，整数除法结果）
DATAS ENDS

STACKS SEGMENT
    ; 堆栈段：未定义具体栈空间，使用系统默认堆栈（用于临时保存寄存器值，如push cx）
STACKS ENDS

CODES SEGMENT
    ; 关联段寄存器：CS指向代码段，DS指向数据段，SS指向堆栈段
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS           ; 将数据段基地址送入AX（因DS不能直接赋值，需通过AX中转）
    MOV DS,AX              ; 初始化数据段寄存器DS，确保程序能正确访问数据段中的变量
    mov ax, 0              ; AX用于累加数组元素的总和（初始化为0，支持有符号数累加）
    mov bx, 0              ; BX作为临时寄存器，暂存当前访问的数组元素
    mov cx, 0              ; CX用于统计数组中有效元素的个数（初始化为0，0不纳入计数）
    mov dx, 0              ; DX用于辅助有符号数累加：存储高位进位/借位（维持符号扩展）
    lea si, num            ; SI指向数组num的起始地址（变址寄存器，用于遍历数组元素）

L:                        ; 循环入口：遍历数组，处理每个元素直到遇到结束标志0
    mov bx, [si]           ; 将SI指向的当前数组元素（字类型）送入BX（暂存当前元素）
    cmp bx, 0              ; 比较当前元素与0（判断是否为数组结束标志）
    je exit                ; 若当前元素为0，跳至exit（结束遍历，进入结果计算环节）
    inc cx                 ; 若为有效元素（非0），元素计数器CX加1（统计有效元素数量）

    ; 处理有符号数累加：通过符号扩展确保累加结果正确（避免符号位丢失）
    push cx                ; 保存当前元素计数器CX的值（防止后续操作覆盖）
    mov cx, 0              ; 重置CX为0（用于非负数的高位扩展：符号位为0）
    cmp bx, 0              ; 判断当前元素是否为非负数（BX ≥ 0）
    jge low_add            ; 若为非负数，跳至low_add（高位扩展为0）
    mov cx, 0ffffh         ; 若为负数，高位扩展为0FFFFH（保持符号位为1，符合有符号数规则）
low_add:                  ; 执行有符号数累加（AX存低16位和，DX存高16位进位/借位）
    add ax, bx             ; AX = AX + 当前元素BX（低16位累加）
    adc dx, cx             ; DX = DX + CX + 进位标志CF（高16位累加，处理进位/借位）
    pop cx                 ; 恢复之前保存的元素计数器CX的值

    ; 初始化最大值和最小值（仅对第一个有效元素执行）
    cmp cx, 1              ; 检查元素计数器CX是否为1（判断是否为第一个有效元素）
    jne check_max          ; 若不是第一个元素，跳至check_max（开始比较最大值）
    mov max, bx            ; 若是第一个元素，将当前元素BX赋值给max（初始化最大值）
    mov min, bx            ; 同时将当前元素BX赋值给min（初始化最小值）
    jmp next_elem          ; 跳至next_elem（处理下一个元素，跳过后续比较）

check_max:                ; 比较并更新最大值
    cmp bx, max            ; 比较当前元素BX与当前最大值max
    jle check_min          ; 若BX ≤ max，不更新最大值，跳至check_min（比较最小值）
    mov max, bx            ; 若BX > max，将当前元素BX赋值给max（更新最大值）

check_min:                ; 比较并更新最小值
    cmp bx, min            ; 比较当前元素BX与当前最小值min
    jge next_elem          ; 若BX ≥ min，不更新最小值，跳至next_elem（处理下一个元素）
    mov min, bx            ; 若BX < min，将当前元素BX赋值给min（更新最小值）

next_elem:                ; 准备访问下一个数组元素
    add si, 2              ; SI加2（因数组元素为字类型，占2字节，指向后一个元素）
    jmp L                  ; 跳回L（继续遍历数组）

exit:                     ; 遍历结束，计算平均值（有符号整数除法）
    idiv cx                ; 有符号除法：DX:AX（元素总和） ÷ CX（有效元素个数），商→AX（平均值）
    mov ave, ax            ; 将计算得到的平均值（商）存入ave变量（余数舍弃，保留整数部分）
    
    ; 以下三行将结果存入寄存器（未执行显示逻辑，仅保存结果供后续扩展）
    mov ax, max            ; 将最大值max送入AX
    mov cx, min            ; 将最小值min送入CX
    mov dx, ave            ; 将平均值ave送入DX

    ; 程序结束，返回DOS系统
    MOV AH,4CH             ; 设置DOS功能调用号为4CH（程序退出并释放资源）
    INT 21H                ; 执行DOS中断，返回DOS环境

CODES ENDS
    END START              ; 汇编程序结束，指定程序入口为START标签
