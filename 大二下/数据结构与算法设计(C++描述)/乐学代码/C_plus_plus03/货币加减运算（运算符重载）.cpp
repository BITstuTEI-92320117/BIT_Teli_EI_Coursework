#include<iostream>
using namespace std;
class Money {
    public:
        friend Money operator +(Money M1, Money M2);
        friend Money operator -(Money M1, Money M2);
        Money(int y, int j, int f);
        Money();
        void display();
    private:
        int yuan;
        int jiao;
        int fen;
};
Money::Money(int y, int j, int f) {
    yuan = y;
    jiao = j;
    fen = f;
}
Money::Money() {
    yuan = 0;
    jiao = 0;
    fen = 0;
}
Money operator +(Money M1, Money M2) {
    int y, j, f;
    y = M1.yuan + M2.yuan;
    j = M1.jiao + M2.jiao;
    f = M1.fen + M2.fen;
    if (f >= 10) {
        f = f - 10;
        j = j + 1;
    }
    if (j >= 10) {
        j = j - 10;
        y = y + 1;
    }
    return Money(y,j,f);
}
Money operator -(Money M1, Money M2) {
    int y, j, f,flag;
    if (M1.yuan > M2.yuan) {
        flag = 0;
    }
    else if (M1.yuan < M2.yuan) {
        flag = 1;
    }
    else {
        if (M1.jiao > M2.jiao) {
            flag = 0;
        }
        else if (M1.jiao<M2.jiao){
            flag = 1;
        }
        else {
            if (M1.fen > M2.fen) {
                flag = 0;
            }
            else {
                flag = 1;
            }
        }
    }
    if (flag == 0) {
        y = M1.yuan - M2.yuan;
        j = M1.jiao - M2.jiao;
        f = M1.fen - M2.fen;
    }
    else {
        y = M2.yuan - M1.yuan;
        j = M2.jiao - M1.jiao;
        f = M2.fen - M1.fen;
    }
    if (f < 0) {
        f = f + 10;
        j = j - 1;
    }
    if (j < 0) {
        j = j + 10;
        if (flag == 1) {
            y = y - 1;
            y = -y;
        }
        else {
            y = y - 1;
        }
    }
    return Money(y, j, f);
}
void Money::display() {
    cout << yuan << "元" << jiao << "角" << fen << "分" << endl;
}
int main() {
    int y1, j1, f1, y2, j2, f2;
    cout << "请输入元、角、分：" << endl;
    cin >> y1 >> j1 >> f1;
    Money M1(y1, j1, f1);
    cout << "请输入元、角、分：" << endl;
    cin >> y2 >> j2 >> f2;
    Money M2(y2, j2, f2), M3, M4;
    M3 = M1 + M2;
    M4 = M1 - M2;
    cout << "和：";
    M3.display(); 
    cout << "差：";
    M4.display();
    return 0;
}