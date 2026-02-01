#include<iostream>
using namespace std;
class Date {
    public:
        Date(int y, int m, int d);
        friend ostream& operator <<(ostream& output, Date& D);
    private:
        int year;
        int month;
        int day;
};
Date::Date(int y, int m, int d) {
    year = y;
    month = m;
    day = d;
}
ostream& operator <<(ostream& output, Date& D) {
    cout << D.year << '-' << D.month << '-' << D.day << endl;
    return output;
}
int main() {
    int y, m, d;
    cin >> y >> m >> d;
    Date D(y, m, d);
    cout << D;
}
