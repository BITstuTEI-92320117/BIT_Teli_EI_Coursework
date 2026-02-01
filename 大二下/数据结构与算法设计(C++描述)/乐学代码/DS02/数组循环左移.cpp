#include<iostream>
#include<string>
using namespace std;
class ver {
public:
    ver(int n);
    void insert(int n);
    void LeftMove(int n, int k);
    void print(int n);
private:
    int n0;
    int a[100];
};
ver::ver(int n) {
    n0 = n;
}
void ver::insert(int n) {
    int i;
    for (i = 0; i <= n - 1; i++) {
        cin >> a[i];
    }
}
void ver::LeftMove(int n, int k) {
    int c, i, j;
    for (i = 0; i <= k - 1; i++) {
        c = a[0];
        for (j = 1; j <= n - 1; j++) {
            a[j - 1] = a[j];
        }
        a[n - 1] = c;
    }
}
void ver::print(int n) {
    int i;
    for (i = 0; i <= n - 2; i++) {
        cout << a[i] << " ";
    }
    cout << a[n - 1] << endl;
}
int main()
{
    int n, k;
    cin >> n;
    cin >> k;
    ver a(n);
    a.insert(n);
    a.LeftMove(n, k);
    a.print(n);
    return 0;
}