#include <iostream>    
#include <string>    
using namespace std;    
    
struct TreeNode {    
    char data;    
    TreeNode* left;    
    TreeNode* right;    
    TreeNode(char val) : data(val), left(nullptr), right(nullptr) {}    
};    
    
TreeNode* buildTree(string& preorder, int& index) {    
    if (index >= preorder.size() || preorder[index] == '#') {    
        index++;    
        return nullptr;    
    }    
    TreeNode* node = new TreeNode(preorder[index++]);    
    node->left = buildTree(preorder, index);    
    node->right = buildTree(preorder, index);    
    return node;    
}    
    
int countLeaves(TreeNode* root) {    
    if (!root) return 0;    
    if (!root->left && !root->right) return 1;    
    return countLeaves(root->left) + countLeaves(root->right);    
}    
    
// 修正后的深度计算：根节点深度为0，边数计算    
int treeDepth(TreeNode* root) {    
    if (!root) return 0;    
    int leftDepth = treeDepth(root->left);    
    int rightDepth = treeDepth(root->right);    
    return max(leftDepth, rightDepth) + 1;    
}    
    
int main() {    
    string preorder;    
    cin >> preorder;    
        
    int index = 0;    
    TreeNode* root = buildTree(preorder, index);    
        
    // 修正输出：如果题目要求根节点深度为0，则手动减1    
    cout << "leafs=" << countLeaves(root) << endl;    
    cout << "Depth=" << (root ? treeDepth(root) - 1 : 0) << endl;    
        
    return 0;    
}  