#include<iostream>
using namespace std;
template<class T>
class input {
    public:
        input(T x, T y);
        void output(T z);
    private:
        T min;
        T max;
};
template<class T>
input<T>::input(T x, T y) {
    min = x;
    max = y;
}
template<class T>
void input<T>::output(T z) {
    if (z >= min && z <= max) {
        cout << z << endl;
    }
    else {
        cout << "数据不符合范围，请重新输入。" << endl;
    }
}
int main() {
    int x, y, z;
    cin >> x >> y >> z;
    char a, b, c;
    cin >> a >> b >> c;
    input< int> in1(x, y);
    in1.output(z);

    input < char> in2(a, b);
    in2.output(c);

}