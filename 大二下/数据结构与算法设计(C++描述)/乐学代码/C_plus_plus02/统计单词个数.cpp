#include<iostream>
#include<string>
using namespace std;
class Words{
    public:
        Words(string s0){
            s=s0;
            cnt=0;
        }
        int countWord();
    private:
        string s;
        int cnt=0;
};
int Words::countWord(){
    int l,i,flag=0;
    l=s.length();
    if (l==0)
        return cnt;
    else{
        for (i=0;i<=l-1;i++){
            if (s[i]>='a'&&s[i]<='z'&&flag==0){
                cnt++;
                flag=1;
            }                
            else if (s[i]>='A'&&s[i]<='Z'&&flag==0){
                cnt++;
                flag=1;
            }  
            else if (s[i]>='A'&&s[i]<='Z'&&flag==1)
                continue;
            else if (s[i]==' ')
                flag=0;
            else
                continue;            
        }
        return cnt;
    }
}
int main(){
    string s;
    getline(cin , s); 
    Words words(s);
    cout<<"Words="<<words.countWord()<<endl;
}