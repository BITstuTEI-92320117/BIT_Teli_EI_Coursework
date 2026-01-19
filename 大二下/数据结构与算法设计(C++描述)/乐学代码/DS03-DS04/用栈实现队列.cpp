#include <iostream>    
#include <stack>    
using namespace std;    
    
class Queue {    
private:    
    stack<int> s1;  // 用于入队    
    stack<int> s2;  // 用于出队    
    
    // 将s1的所有元素转移到s2    
    void transfer() {    
        while (!s1.empty()) {    
            s2.push(s1.top());    
            s1.pop();    
        }    
    }    
    
public:    
    void enqueue(int value) {    
        s1.push(value);    
    }    
    
    int dequeue() {    
        if (s2.empty()) {    
            transfer();    
        }    
        int value = s2.top();    
        s2.pop();    
        return value;    
    }    
    
    bool isEmpty() {    
        return s1.empty() && s2.empty();    
    }    
};    
    
int main() {    
    Queue queue;    
    string op;    
    int x;    
    
    while (cin >> op) {    
        if (op == "enqueue") {    
            cin >> x;    
            queue.enqueue(x);    
        } else if (op == "dequeue") {    
            cout << queue.dequeue() << endl;    
        } else if (op == "isEmpty") {    
            cout << (queue.isEmpty() ? 1 : 0) << endl;    
        }    
    }    
    
    return 0;    
}  