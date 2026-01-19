#include<iostream>
#include<string>
using namespace std;
class Client{
    public:
        Client(int age,string name){
            n=name;
            a=age;  
        }
        void Cout();
    private:
    int a;
    string n;
};
void Client::Cout(){
    cout<<"Name:"<<n<<endl;
    cout<<"Age:"<<a<<endl;
}
int main(){
    int a;
    string name;
    cin>>name>>a;
    Client client(a,name);
    client.Cout();
}