#include<iostream>
using namespace std;
template<class T>
class Store {
    public:
        void putElem(T t);
        T getElem();
    private:
        T item;
};
template<class T>
void Store<T>::putElem(T t) {
    item = t;
}
template<class T>
T Store<T>::getElem() {
    return item;
}
int main() {

    int a;
    double b;
    cout << "请输入整变量a，以及浮点型变量b：" << endl;
    cin >> a >> b;

    Store<int> s1;
    Store<double> s2;
    s1.putElem(a);
    s2.putElem(b);
    cout << "s1.getElem() = " << s1.getElem() << "  " << "s2.getElem() = " << s2.getElem() << endl;

    return 0;
}