%% 左右移防错位函数
% OutputCode: 矫正后的序列;
% shift: 左移为-1，右移为1，不移为0;
function [OutputCode, shift] = shift_compare(Input_Code, Standard_Code)
    Len = length(Input_Code);
    originError_Code = abs(Input_Code - Standard_Code);
    originError_Num = sum(originError_Code);
    originError_Rate = originError_Num / Len;
    %fprintf('不移位误码率：%f\n',originError_Rate);
    %left
    leftInput_Code = zeros(1,Len);
    leftInput_Code(1:Len-1) = Input_Code(2:Len);
    leftInput_Code(end) = Standard_Code(end);
    leftError_Code = abs(leftInput_Code - Standard_Code);
    leftError_Num = sum(leftError_Code);
    leftError_Rate = leftError_Num / Len;
    %fprintf('左移位误码率：%f\n',leftError_Rate);    
    %right
    rightInput_Code = zeros(1,Len);
    rightInput_Code(2:Len) = Input_Code(1:Len-1);
    rightInput_Code(1) = Standard_Code(1);
    rightError_Code = abs(rightInput_Code - Standard_Code);
    rightError_Num = sum(rightError_Code);
    rightError_Rate = rightError_Num / Len;
    %fprintf('右移位误码率：%f\n',rightError_Rate);  
    if originError_Rate < 0.2
        OutputCode = Input_Code;
        shift = 0;
    elseif leftError_Rate < 0.1
        OutputCode = leftInput_Code;
        shift = -1;  
    elseif rightError_Rate < 0.1
        OutputCode = rightInput_Code;
        shift = 1;   
    else
        OutputCode = Input_Code;
        shift = 0;
    end       
end