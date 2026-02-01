#include <iostream>
#include <fstream>
#include <queue>    // 用于优先队列
#include <map>      // 用于存储频率表和编码表
#include <vector>   // 用于优先队列容器
#include <bitset>   // 用于位操作
using namespace std;

class HuffmanTree;  //声明哈夫曼树管理类 
/* 哈夫曼树节点类，表示哈夫曼树中的每个节点 */
class HuffmanNode {
private:
	char data;        // 存储字符（叶节点有效）
	int freq;         // 字符出现的频率/权重
    HuffmanNode* left;  // 左子节点指针
    HuffmanNode* right; // 右子节点指针
    friend HuffmanTree; //友元类 
    
public:
    // 构造函数：初始化节点数据和频率
    HuffmanNode(char d, int f) 
        : data(d), freq(f), left(nullptr), right(nullptr) {}
};

/* 哈夫曼树管理类，构建哈夫曼树并生成字符编码表*/
class HuffmanTree {
private:
    HuffmanNode* root;       // 树的根节点
    map<char, string> huffmanCode; // 字符到二进制编码的映射表

    /* 递归生成字符编码，参数：node-当前节点，code-累计生成的二进制编码*/
    void generateCodes(HuffmanNode* node, string code) {
        if (!node) return;
        
        // 如果是叶节点，存储编码
        if (!node->left && !node->right) {
            huffmanCode[node->data] = code;
            return;
        }
        
        // 左子树编码追加'0'，右子树追加'1'
        generateCodes(node->left, code + "0");
        generateCodes(node->right, code + "1");
    }

    /* 递归删除树节点，参数：node-当前要删除的节点*/
    void deleteTree(HuffmanNode* node) {
        if (node) {
            deleteTree(node->left);
            deleteTree(node->right);
            delete node;
        }
    }

public:
    HuffmanTree() : root(nullptr) {}
    ~HuffmanTree() { deleteTree(root); } // 析构时自动释放内存

    /* 构建哈夫曼树，参数：freqMap-包含字符频率的映射表*/
    void buildTree(const map<char, int>& freqMap) {
        // 自定义优先队列比较器（按频率升序排列）
        auto cmp = [](HuffmanNode* a, HuffmanNode* b) { return a->freq > b->freq; };
        priority_queue<HuffmanNode*, vector<HuffmanNode*>, decltype(cmp)> pq(cmp);

        // 创建初始叶节点
        for (auto& pair : freqMap) {
            pq.push(new HuffmanNode(pair.first, pair.second));
        }

        // 合并节点直到只剩一个根节点
        while (pq.size() > 1) {
            // 取出两个最小频率节点
            HuffmanNode* left = pq.top(); pq.pop();
            HuffmanNode* right = pq.top(); pq.pop();
            
            // 创建新父节点（字符数据设为'\0'）
            HuffmanNode* parent = new HuffmanNode('\0', left->freq + right->freq);
            parent->left = left;
            parent->right = right;
            pq.push(parent);
        }
        
        // 获取最终根节点并生成编码
        if (!pq.empty()) root = pq.top();
        generateCodes(root, "");
    }

    // 获取生成的编码表
    map<char, string> getCodes() const { return huffmanCode; }
};

/* 文件处理类
 * 功能：处理所有文件IO相关操作
 */
class FileHandler {
public:
    /* 读取文件并统计字符频率
     * 参数：filename-要读取的文件名
     * 返回：字符频率映射表
     */
    static map<char, int> readFile(const string& filename) {
        ifstream fin(filename, ios::binary);
        if (!fin) {
            cerr << "无法打开文件: " << filename << endl;
            exit(1);
        }

        map<char, int> freq;
        char ch;
        while (fin.get(ch)) freq[ch]++; // 统计每个字符出现次数
        fin.close();
        return freq;
    }

    /* 写入压缩文件
     * 参数：filename-原始文件名，codes-哈夫曼编码表
     */
    static void writeEncoded(const string& filename, const map<char, string>& codes) {
        ofstream fout(filename + ".huff", ios::binary);
        if (!fout) {
            cerr << "无法创建输出文件" << endl;
            exit(1);
        }

        // 写入字符数量（1字节）
        unsigned char size = codes.size();
        fout.write(reinterpret_cast<char*>(&size), 1);

        // 写入编码表结构：字符(1B) + 编码长度(1B) + 编码内容(变长)
        for (auto& pair : codes) {
            fout.put(pair.first);          // 写入字符
            unsigned char len = pair.second.size(); // 编码位数
            fout.put(len);                 // 写入编码长度
            fout << pair.second;           // 写入二进制编码字符串
        }

        // 二次读取文件进行压缩
        ifstream fin(filename, ios::binary);
        string bitStr;  // 累积位字符串
        char ch;
        while (fin.get(ch)) {
            bitStr += codes.at(ch); // 追加当前字符的编码
            
            // 每当累积满8位（1字节）就写入文件
            while (bitStr.size() >= 8) {
                bitset<8> bits(bitStr.substr(0, 8)); // 截取前8位
                fout.put(static_cast<char>(bits.to_ulong())); // 转为字节写入
                bitStr = bitStr.substr(8); // 移除已处理位
            }
        }

        // 处理剩余不足8位的部分
        if (!bitStr.empty()) {
            // 用0填充右侧空位
            bitset<8> bits(bitStr);
            fout.put(static_cast<char>(bits.to_ulong()));
        }

        fin.close();
        fout.close();
    }

    /* 解压文件
     * 参数：filename-压缩文件名（.huff）
     */
    static void decodeFile(const string& filename) {
        ifstream fin(filename, ios::binary);
        if (!fin) {
            cerr << "文件打开失败" << endl;
            exit(1);
        }

        // 读取字符数量（文件第一个字节）
        unsigned char size;
        fin.read(reinterpret_cast<char*>(&size), 1);

        // 构建编码到字符的反向映射表
        map<string, char> decodeMap;
        for (int i = 0; i < size; ++i) {
            char data;
            unsigned char codeLen;
            string code;

            fin.get(data);                     // 读取字符
            fin.get(reinterpret_cast<char&>(codeLen)); // 读取编码长度
            code.resize(codeLen);              // 设置编码字符串长度
            fin.read(&code[0], codeLen);       // 读取编码内容
            decodeMap[code] = data;            // 建立映射关系
        }

        // 创建解压后文件（原文件名_decoded）
        string outputFile = filename.substr(0, filename.find(".huff")) + "_decoded";
        ofstream fout(outputFile, ios::binary);

        // 读取压缩数据并解码
        string bitStr;  // 累积位字符串
        char byte;
        while (fin.get(byte)) {
            bitset<8> bits(byte);               // 将字节转为8位二进制字符串
            bitStr += bits.to_string();         // 追加到累积字符串
            
            // 持续尝试匹配编码
            bool found;
            do {
                found = false;
                // 遍历所有可能的编码
                for (auto& pair : decodeMap) {
                    // 检查是否以当前编码开头
                    if (bitStr.find(pair.first) == 0) {
                        fout.put(pair.second);  // 写入对应字符
                        bitStr = bitStr.substr(pair.first.size()); // 移除已匹配位
                        found = true;
                        break;
                    }
                }
            } while (found && !bitStr.empty()); // 直到无法匹配为止
        }

        fin.close();
        fout.close();
    }
};

/* 主控制类
 * 功能：协调压缩和解压流程
 */
class HuffmanCompressor {
public:
    /* 执行压缩流程 */
    static void compress(const string& filename) {
        map<char, int> freq = FileHandler::readFile(filename); // 统计频率
        HuffmanTree htree;
        htree.buildTree(freq);                  // 构建哈夫曼树
        FileHandler::writeEncoded(filename, htree.getCodes()); // 写入压缩文件
        cout << "压缩成功: " << filename << ".huff" << endl;
    }

    /* 执行解压流程 */
    static void decompress(const string& filename) {
        FileHandler::decodeFile(filename);     // 解码文件
        cout << "解压成功: " 
             << filename.substr(0, filename.find(".huff")) << "_decoded" << endl;
    }
};

/* 主函数：用户界面 */
int main() {
    int choice;
    string filename;

    cout << "1. 压缩文件\n2. 解压文件\n请选择操作: ";
    cin >> choice;
    cin.ignore(); // 清除输入缓冲区中的换行符

    cout << "输入文件名: ";
    getline(cin, filename); // 支持带空格的文件名

    if (choice == 1) {
        HuffmanCompressor::compress(filename);
    } else if (choice == 2) {
        HuffmanCompressor::decompress(filename);
    } else {
        cout << "无效选择" << endl;
    }

    cout << "操作完成，按回车退出...";
    cin.get(); // 等待用户确认
    return 0;
}
