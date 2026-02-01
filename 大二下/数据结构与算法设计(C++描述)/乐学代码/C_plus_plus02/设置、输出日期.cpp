#include<iostream>
using namespace std;
class Date{
    public:
        Date(int y,int m,int d){
            year=y;
            month=m;
            day=d;
        }
        int Cout();
    private:
        int year;
        int month;
        int day;
        int GetDay(int d);
        int GetMonth(int m);
        int GetYear(int y);
        void ShowDate(int y,int m,int d);
};
int Date::GetDay(int d){
    cout<<"day "<<d<<endl;
}
int Date::GetMonth(int m){
    cout<<"month "<<m<<endl;
}
int Date::GetYear(int y){
    cout<<"year "<<y<<endl;
}
int Date::Cout(){
    ShowDate(year,month,day);
    GetYear(year);
    GetMonth(month);
    GetDay(day);
}
void Date::ShowDate(int y,int m,int d){
    cout<<y<<"/"<<m<<"/"<<d<<endl;
}
int main(){
    int y,m,d;
    cin>>y>>m>>d;
    Date date(y,m,d);
    date.Cout();
}