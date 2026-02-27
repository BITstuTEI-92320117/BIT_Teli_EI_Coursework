#include<iostream>
using namespace std;
class Time;
class Date {
    private:
        int year;
        int month;
        int day;
    public:
        friend void display(Date D, Time T);
        Date(int y, int m, int d) {
            year = y;
            month = m;
            day = d;
        }
};
class Time {
    private:
        int hour;
        int minute;
        int second;
    public:
        friend void display(Date D, Time T);
        Time(int h, int m, int s) {
            hour = h;
            minute = m;
            second = s;
        }
};
void display(Date D, Time T) {
    cout << D.year << '/' << D.month << '/' << D.day << endl;
    cout << T.hour << ':' << T.minute << ':' << T.second << endl;
}
int main() {
    int y, m1, d, h, m2, s;
    cin >> y >> m1 >> d >> h >> m2 >> s;
    Date D(y, m1, d);
    Time T(h, m2, s);
    display(D, T);
    return 0;
}