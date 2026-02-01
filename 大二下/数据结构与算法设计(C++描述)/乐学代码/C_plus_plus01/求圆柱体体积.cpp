#include<iostream>
using namespace std;
inline double square(double r,double h){
    return 3.14*r*r*h;
}
int main(){
    double r,h,s;
    cin>>r>>h;
    s=square(r,h);
    cout<<"v="<<s<<endl;
    return 0;
}