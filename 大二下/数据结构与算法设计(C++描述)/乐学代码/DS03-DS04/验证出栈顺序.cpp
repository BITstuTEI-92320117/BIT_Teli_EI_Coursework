#include <iostream>    
#include <stack>    
#include <vector>    
using namespace std;    
    
bool isValidPopSequence(const vector<int>& pushOrder, const vector<int>& popOrder) {    
    int n = pushOrder.size();    
    stack<int> s;    
    int popIndex = 0;    
        
    for (int num : pushOrder) {    
        s.push(num);    
        // 检查是否可以弹出元素以匹配popOrder    
        while (!s.empty() && popIndex < n && s.top() == popOrder[popIndex]) {    
            s.pop();    
            popIndex++;    
        }    
    }    
    return popIndex == n;  // 如果所有元素都被正确弹出，则序列有效    
}    
    
int main() {    
    int n;    
    cin >> n;    
        
    vector<int> pushOrder(n);    
    vector<int> popOrder(n);    
        
    // 读取入栈顺序    
    for (int i = 0; i < n; i++) {    
        cin >> pushOrder[i];    
    }    
        
    // 读取待验证的出栈顺序    
    for (int i = 0; i < n; i++) {    
        cin >> popOrder[i];    
    }    
        
    // 判断并输出结果    
    cout << (isValidPopSequence(pushOrder, popOrder)     
                ? "The pop order is possible.\n"     
                : "The pop order is impossible.\n");    
        
    return 0;    
}  