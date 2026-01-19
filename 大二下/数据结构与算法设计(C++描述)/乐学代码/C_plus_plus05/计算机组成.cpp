#include<iostream>
using namespace std;
class CPU {
    public:
        virtual void show() = 0;
};
class ICPU :public CPU {
    public:
        void show();
};
class LCPU :public CPU {
    public:
        void show();
};
class DisplayCard {
    public:
        virtual void show() = 0;
};
class IDisplayCard :public DisplayCard {
    public:
        void show();
};
class LDisplayCard :public DisplayCard {
    public:
        void show();
};
class MemoryStick {
public:
    virtual void show() = 0;
};
class IMemoryStick :public MemoryStick {
public:
    void show();
};
class LMemoryStick :public MemoryStick {
public:
    void show();
};
void ICPU::show() {
    cout << "Intel的CPU开始计算了" << endl;
}
void LCPU::show() {
    cout << "Lenovo的CPU开始计算了" << endl;
}
void IDisplayCard::show() {
    cout << "Intel的显卡开始显示了" << endl;
}
void LDisplayCard::show() {
    cout << "Lenovo的显卡开始显示了" << endl;
}
void IMemoryStick::show() {
    cout << "Intel的内存条开始存储了" << endl;
}
void LMemoryStick::show() {
    cout << "Lenovo的内存条开始存储了" << endl;
}
int main() {
    int m, n, k;
    cin >> m >> n >> k;
    CPU* pc;
    DisplayCard* pd;
    MemoryStick* pm;
    if (m == 1) {
        ICPU C;
        pc = &C;
        pc->show();
    }
    else {
        LCPU C;
        pc = &C;
        pc->show();
    }
    if (n == 1) {
        IDisplayCard D;
        pd = &D;
        pd->show();
    }
    else {
        LDisplayCard D;
        pd = &D;
        pd->show();
    }
    if (k == 1) {
        IMemoryStick M;
        pm = &M;
        pm->show();
    }
    else {
        LMemoryStick M;
        pm = &M;
        pm->show();
    }
    return 0;
}