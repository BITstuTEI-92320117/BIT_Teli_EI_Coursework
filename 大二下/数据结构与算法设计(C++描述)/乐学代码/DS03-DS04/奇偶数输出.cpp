#include <iostream>    
using namespace std;    
    
// 定义链队节点结构    
struct Node {    
    int data;    
    Node* next;    
    Node(int val) : data(val), next(nullptr) {}    
};    
    
// 定义链队类    
class LinkedQueue {    
private:    
    Node* front;    
    Node* rear;    
public:    
    LinkedQueue() : front(nullptr), rear(nullptr) {}    
        
    bool isEmpty() const {    
        return front == nullptr;    
    }    
        
    void enqueue(int val) {    
        Node* newNode = new Node(val);    
        if (isEmpty()) {    
            front = rear = newNode;    
        } else {    
            rear->next = newNode;    
            rear = newNode;    
        }    
    }    
        
    int dequeue() {    
        if (isEmpty()) {    
            cerr << "Queue is empty!" << endl;    
            return -1;    
        }    
        int val = front->data;    
        Node* temp = front;    
        front = front->next;    
        if (front == nullptr) {    
            rear = nullptr;    
        }    
        delete temp;    
        return val;    
    }    
};    
    
int main() {    
    int n;    
    cin >> n;    
        
    LinkedQueue Q1, Q2;  // Q1存储奇数，Q2存储偶数    
        
    // 读取输入并分类存入队列    
    for (int i = 0; i < n; ++i) {    
        int num;    
        cin >> num;    
        if (num % 2 == 1) {    
            Q1.enqueue(num);    
        } else {    
            Q2.enqueue(num);    
        }    
    }    
        
    // 配对输出    
    while (!Q1.isEmpty() && !Q2.isEmpty()) {    
        cout << Q1.dequeue() << " " << Q2.dequeue() << endl;    
    }    
        
    return 0;    
}  