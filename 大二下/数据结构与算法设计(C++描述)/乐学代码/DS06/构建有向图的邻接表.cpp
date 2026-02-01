#include <iostream> 
#include <vector> 
#include <string> 
#include <map> 
using namespace std; 
 
struct Node { 
    int index; 
    Node* next; 
    Node(int idx) : index(idx), next(nullptr) {} 
}; 
 
struct HeadNode { 
    string info; 
    Node* next; 
    Node* tail;  // ����βָ������β�巨 
    HeadNode() : info(""), next(nullptr), tail(nullptr) {} 
}; 
 
int main() { 
    int t; 
    cin >> t; 
     
    while (t--) { 
        int n, k; 
        cin >> n >> k; 
         
        vector<string> vertices(n); 
        map<string, int> vertex_index_map; 
         
        for (int i = 0; i < n; i++) { 
            cin >> vertices[i]; 
            vertex_index_map[vertices[i]] = i; 
        } 
         
        vector<HeadNode> adj_list(n); 
        for (int i = 0; i < n; i++) { 
            adj_list[i].info = vertices[i]; 
        } 
         
        for (int i = 0; i < k; i++) { 
            string u, v; 
            cin >> u >> v; 
            int u_idx = vertex_index_map[u]; 
            int v_idx = vertex_index_map[v]; 
             
            Node* new_node = new Node(v_idx); 
             
            // ʹ��β�巨��������˳�� 
            if (adj_list[u_idx].next == nullptr) { 
                adj_list[u_idx].next = new_node; 
                adj_list[u_idx].tail = new_node; 
            } else { 
                adj_list[u_idx].tail->next = new_node; 
                adj_list[u_idx].tail = new_node; 
            } 
        } 
         
        for (int i = 0; i < n; i++) { 
            cout << i << " " << adj_list[i].info; 
            Node* current = adj_list[i].next; 
            while (current != nullptr) { 
                cout << "-" << current->index; 
                current = current->next; 
            } 
            cout << "-^" << endl; 
        } 
         
        // �ͷ��ڴ� 
        for (int i = 0; i < n; i++) { 
            Node* current = adj_list[i].next; 
            while (current != nullptr) { 
                Node* temp = current; 
                current = current->next; 
                delete temp; 
            } 
        } 
    } 
     
    return 0; 
}  