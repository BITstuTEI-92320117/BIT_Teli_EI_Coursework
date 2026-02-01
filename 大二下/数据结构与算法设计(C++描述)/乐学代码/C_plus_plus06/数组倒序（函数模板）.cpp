#include<iostream>
using namespace std;
template<class T>
void outputArray(T* arr, int cnt) {
    int i;
    for (i = cnt - 1; i >= 0 ; i--) {
        cout << arr[i] << " ";
    }
    cout << endl;
}
int main() {

    int A_COUNT, B_COUNT, C_COUNT;
    cout << "请输入整型数组、浮点型数组、字符型数组的长度：" << endl;
    cin >> A_COUNT >> B_COUNT >> C_COUNT;

    int* arr_int = new int[A_COUNT];

    double* arr_double = new double[B_COUNT];

    char* arr_char = new char[C_COUNT];

    cout << "请输入长度为" << A_COUNT << "的整型数组：" << endl;
    for (int i = 0; i < A_COUNT; ++i)
        cin >> arr_int[i];

    cout << "请输入长度为" << B_COUNT << "的浮点型数组：" << endl;
    for (int i = 0; i < B_COUNT; ++i)
        cin >> arr_double[i];

    cout << "请输入长度为" << C_COUNT << "的字符型数组：" << endl;
    for (int i = 0; i < C_COUNT; ++i)
        cin >> arr_char[i];


    cout << "倒序输出整型数组：" << endl;

    outputArray(arr_int, A_COUNT);

    cout << "倒序输出浮点型数组：" << endl;

    outputArray(arr_double, B_COUNT);

    cout << "倒序输出字符型数组：" << endl;

    outputArray(arr_char, C_COUNT);
    return 0;
}