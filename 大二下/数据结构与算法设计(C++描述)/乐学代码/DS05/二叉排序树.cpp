#include <iostream>    
#include <vector>    
using namespace std;    
    
struct TreeNode {    
    int data;    
    TreeNode* left;    
    TreeNode* right;    
    TreeNode(int val) : data(val), left(nullptr), right(nullptr) {}    
};    
    
TreeNode* insert(TreeNode* root, int val) {    
    if (!root) return new TreeNode(val);    
    if (val < root->data)    
        root->left = insert(root->left, val);    
    else    
        root->right = insert(root->right, val);    
    return root;    
}    
    
TreeNode* findMin(TreeNode* root) {    
    while (root->left) root = root->left;    
    return root;    
}    
    
// 返回值: first=新的根节点, second=是否删除成功    
pair<TreeNode*, bool> deleteNode(TreeNode* root, int val) {    
    if (!root) return make_pair(root, false);    
        
    if (val < root->data) {    
        pair<TreeNode*, bool> result = deleteNode(root->left, val);    
        root->left = result.first;    
        return make_pair(root, result.second);    
    } else if (val > root->data) {    
        pair<TreeNode*, bool> result = deleteNode(root->right, val);    
        root->right = result.first;    
        return make_pair(root, result.second);    
    } else {    
        if (!root->left) {    
            TreeNode* temp = root->right;    
            delete root;    
            return make_pair(temp, true);    
        } else if (!root->right) {    
            TreeNode* temp = root->left;    
            delete root;    
            return make_pair(temp, true);    
        }    
            
        TreeNode* temp = findMin(root->right);    
        root->data = temp->data;    
        pair<TreeNode*, bool> result = deleteNode(root->right, temp->data);    
        root->right = result.first;    
        return make_pair(root, true);    
    }    
}    
    
void inorder(TreeNode* root) {    
    if (root) {    
        inorder(root->left);    
        cout << root->data << "  ";    
        inorder(root->right);    
    }    
}    
    
void destroyTree(TreeNode* root) {    
    if (root) {    
        destroyTree(root->left);    
        destroyTree(root->right);    
        delete root;    
    }    
}    
    
int main() {    
    int n, value;    
    cin >> n;    
        
    vector<int> data(n);    
    TreeNode* root = nullptr;    
        
    for (int i = 0; i < n; ++i) {    
        cin >> data[i];    
        root = insert(root, data[i]);    
    }    
        
    cin >> value;    
        
    cout << "原始数据：";    
    for (int num : data) {    
        cout << num << " ";    
    }    
    cout << endl;    
        
    cout << "中序遍历结果：";    
    inorder(root);    
    cout << endl;    
        
    pair<TreeNode*, bool> result = deleteNode(root, value);    
    root = result.first;    
        
    if (result.second) {    
        cout << "删除结点后结果：";    
        inorder(root);    
        cout << endl;    
    } else {    
        cout << "删除结点后结果：没有" << value << "结点。" << endl;    
    }    
        
    destroyTree(root);    
    return 0;    
}  