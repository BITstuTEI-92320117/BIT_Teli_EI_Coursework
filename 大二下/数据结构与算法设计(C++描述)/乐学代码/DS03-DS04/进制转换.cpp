#include <iostream>    
#include <stack>    
#include <string>    
using namespace std;    
    
string decimalToHexadecimal(int num) {    
    if (num == 0) return "0";    
        
    stack<char> digits;    
    bool isNegative = num < 0;    
    if (isNegative) num = -num;  // 处理负数    
        
    while (num > 0) {    
        int remainder = num % 16;    
        if (remainder < 10) {    
            digits.push(remainder + '0');  // 0-9    
        } else {    
            digits.push(remainder - 10 + 'A');  // A-F    
        }    
        num /= 16;    
    }    
        
    string hexStr = isNegative ? "-" : "";    
    while (!digits.empty()) {    
        hexStr += digits.top();    
        digits.pop();    
    }    
    return hexStr;    
}    
    
int main() {    
    int num;    
    cin >> num;    
    cout << decimalToHexadecimal(num) << endl;    
    return 0;    
}  