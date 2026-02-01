#include <iostream>    
#include <vector>    
#include <string>    
using namespace std;    
    
int main() {    
    int n, m;    
    cout << "请输入图的顶点数和边数：" << endl;    
    cin >> n >> m;    
        
    vector<string> vertices(n);    
    cout << "请输入图的各个顶点的信息（A,B…）：" << endl;    
    for (int i = 0; i < n; ++i) {    
        cin >> vertices[i];    
    }    
        
    // 初始化邻接矩阵为0    
    vector<vector<int>> adjMatrix(n, vector<int>(n, 0));    
        
    cout << "请输入各条边的信息（例：1 2表示在A顶点和B顶点之间有一条边）:" << endl;    
    for (int i = 0; i < m; ++i) {    
        int uIdx, vIdx;    
        int weight;    
        cin >> uIdx >> vIdx >> weight;    
            
        // 转换为0-based索引    
        uIdx--;    
        vIdx--;    
            
        // 检查索引有效性    
        if (uIdx >= 0 && uIdx < n && vIdx >= 0 && vIdx < n) {    
            adjMatrix[uIdx][vIdx] = weight;    
            adjMatrix[vIdx][uIdx] = weight;  // 无向图对称    
        }    
    }    
        
    // 输出邻接矩阵    
    cout << "  ";    
    for (const auto& v : vertices) {    
        cout << v << " ";    
    }    
    cout << endl;    
        
    for (int i = 0; i < n; ++i) {    
        cout << vertices[i] << " ";    
        for (int j = 0; j < n; ++j) {    
            cout << adjMatrix[i][j] << " ";    
        }    
        cout << endl;    
    }    
        
    return 0;    
}  