#include <iostream>  
#include <vector>  
#include <string>  
#include <algorithm>  
using namespace std;  
  
int dfs(const vector<string>& tokens, int& index, int& max_diameter) {  
    if (index >= tokens.size()) {  
        return -1;  
    }  
    string token = tokens[index];  
    index++;  
    if (token == "#") {  
        return -1;  
    }  
    int left_depth = dfs(tokens, index, max_diameter);  
    int right_depth = dfs(tokens, index, max_diameter);  
    int path_length = left_depth + right_depth + 2;  
    if (path_length > max_diameter) {  
        max_diameter = path_length;  
    }  
    return max(left_depth, right_depth) + 1;  
}  
  
int main() {  
    string input;  
    getline(cin, input);  
    if (input.empty()) {  
        cout << 0 << endl;  
        return 0;  
    }  
    vector<string> tokens;  
    size_t start = 0;  
    size_t end = input.find(' ');  
    while (end != string::npos) {  
        tokens.push_back(input.substr(start, end - start));  
        start = end + 1;  
        end = input.find(' ', start);  
    }  
    tokens.push_back(input.substr(start));  
    int index = 0;  
    int max_diameter = 0;  
    dfs(tokens, index, max_diameter);  
    cout << max_diameter << endl;  
    return 0;  
}  