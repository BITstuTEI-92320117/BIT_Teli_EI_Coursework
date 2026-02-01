#include<iostream>
using namespace std;
int main(){
    int m,n,k,max=0;
    cin>>m>>n>>k;
    if (m>n){
        max=m;
    }
    else{
        max=n;
    }
    if (max>k){
        cout<<"Maximum:"<<max<<endl;
    }
    else{
        cout<<"Maximum:"<<k<<endl;
    }
}