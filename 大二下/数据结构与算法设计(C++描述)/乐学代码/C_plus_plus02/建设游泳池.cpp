#include<iostream>
using namespace std;
class Circle{
    public:
        Circle(int r1){
            r=r1;
            pi=3.14159;
        }
        void Cout();
    private:
        int r;
        double pi;  
};
void Circle::Cout(){
    cout<<"Enter the radius of the pool:"<<r<<endl;
    cout<<"Fencing Cost is "<<2*pi*(r+3)*35<<endl;
    cout<<"Concrete Cost is "<<pi*((r+3)*(r+3)-r*r)*20<<endl;
}
int main(){
    int r;
    cin>>r;
    Circle circle(r);
    circle.Cout();
}