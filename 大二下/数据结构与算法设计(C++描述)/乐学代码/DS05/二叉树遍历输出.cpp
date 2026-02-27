#include <iostream>    
#include <string>    
using namespace std;    
    
// 二叉树节点结构    
struct TreeNode {    
    char data;    
    TreeNode* left;    
    TreeNode* right;    
    TreeNode(char val) : data(val), left(nullptr), right(nullptr) {}    
};    
    
// 根据先序遍历序列构建二叉树    
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
    
// 先序遍历（带空格）    
void preOrder(TreeNode* root) {    
    if (root) {    
        cout << root->data << " ";    
        preOrder(root->left);    
        preOrder(root->right);    
    }    
}    
    
// 中序遍历（带空格）    
void inOrder(TreeNode* root) {    
    if (root) {    
        inOrder(root->left);    
        cout << root->data << " ";    
        inOrder(root->right);    
    }    
}    
    
// 后序遍历（带空格）    
void postOrder(TreeNode* root) {    
    if (root) {    
        postOrder(root->left);    
        postOrder(root->right);    
        cout << root->data << " ";    
    }    
}    
    
// 释放二叉树内存    
void destroyTree(TreeNode* root) {    
    if (root) {    
        destroyTree(root->left);    
        destroyTree(root->right);    
        delete root;    
    }    
}    
    
int main() {    
    string preorder;    
    cin >> preorder;    
        
    int index = 0;    
    TreeNode* root = buildTree(preorder, index);    
        
    // 输出三种遍历结果    
    cout << "前序遍历结果：";    
    preOrder(root);    
    cout << endl;    
        
    cout << "中序遍历结果：";    
    inOrder(root);    
    cout << endl;    
        
    cout << "后序遍历结果：";    
    postOrder(root);    
    cout << endl;    
        
    // 释放内存    
    destroyTree(root);    
        
    return 0;    
}  
跳至...