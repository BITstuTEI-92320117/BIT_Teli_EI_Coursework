#include<iostream>
using namespace std;
class Four {
    public:
        Four(int n);
        int GetValue();
        Four operator +(Four F);
        int value10;
    private:
        int value4;
};
Four::Four(int n) {
    value4 = n;
    int i = 1;
    value10 = 0;
    while (n  > 0) {
        value10 = value10 + i * (n % 10);
        i = i * 4;
        n = n / 10;
    }
}
Four Four ::operator +(Four F) {
    int Ten, i = 1, f = 0;
    Ten = value10 + F.value10;;
    while (Ten > 0) {
        f = f + i * (Ten % 4);
        Ten = Ten / 4;
        i = i * 10;
    }
    return Four(f);
}
int Four::GetValue() {
    cout << value4 << endl;
    return 0;
}
int main() {
    int m, n, i;
    cin >> n;
    Four F1(0);
    for (i = 1; i <= n; i++) {
        cin >> m;
        Four F2(m);
        F1 = F1 + F2;
    }
    F1.GetValue();
}
