#pragma once
#include"BankAccount.h"
//管理员类
class Manager {
public:
    Manager();
    bool login();
    void browse(BankAccount* pt, int number);
    void search(BankAccount* pt, int number);
    void transfer(BankAccount* p);
    void display(BankAccount* p, int n);
    bool types1(BankAccount* pt0, int n, string s);
    bool types2(BankAccount* pt2, int min, int max);
    int reflesh(BankAccount* p);
private:
        //管理员密码
    string password;
};
