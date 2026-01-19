#include <iostream>    
#include <stack>    
#include <string>    
using namespace std;    
    
bool isValid(string expr) {    
    stack<char> s;    
    for (char c : expr) {    
        // 遇到左括号，入栈    
        if (c == '(' || c == '[' || c == '{') {    
            s.push(c);    
        }    
        // 遇到右括号，检查匹配    
        else if (c == ')' || c == ']' || c == '}') {    
            if (s.empty()) return false;    
            char top = s.top();    
            s.pop();    
            if ((c == ')' && top != '(') ||     
                (c == ']' && top != '[') ||     
                (c == '}' && top != '{')) {    
                return false;    
            }    
        }    
        // 非括号字符，跳过    
    }    
    // 栈为空表示所有括号都匹配    
    return s.empty();    
}    
    
int main() {    
    string expr;    
    getline(cin, expr);  // 读取整行表达式    
    cout << (isValid(expr) ? "括号配对" : "括号不配对") << endl;    
    return 0;    
}  