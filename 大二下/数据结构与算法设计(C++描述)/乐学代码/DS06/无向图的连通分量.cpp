#include <iostream> 
#include <vector> 
using namespace std; 
 
void dfs(int node, vector<bool>& visited, const vector<vector<int>>& graph) { 
    visited[node] = true; 
    for (int neighbor : graph[node]) { 
        if (!visited[neighbor]) { 
            dfs(neighbor, visited, graph); 
        } 
    } 
} 
 
int main() { 
    int n, m; 
    cin >> n >> m; 
     
    // �����ڽӱ� 
    vector<vector<int>> graph(n); 
     
    // ��������� 
    for (int i = 0; i < m; i++) { 
        int u, v; 
        cin >> u >> v; 
        graph[u].push_back(v); 
        graph[v].push_back(u); 
    } 
     
    // ���ʱ������ 
    vector<bool> visited(n, false); 
    int components = 0; 
     
    // �������нڵ� 
    for (int i = 0; i < n; i++) { 
        if (!visited[i]) { 
            components++; 
            dfs(i, visited, graph); 
        } 
    } 
     
    cout << components << endl; 
     
    return 0; 
}  