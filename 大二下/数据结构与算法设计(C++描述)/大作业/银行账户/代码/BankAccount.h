#pragma once
#include<string>
#include<iostream>
#include<cstdlib>
using namespace std;
class BankAccount {
public:
    BankAccount();
    BankAccount(string _ID, string _password, string _name, string _telephone, string _account_number, string _email, string _IDcard, double _balance);
private:
    string ID;
    string name;
    string telephone;
    string email;
    string IDcard;
    string account_number;
    string password;
    double balance;
    BankAccount* head;
    BankAccount* next;
    friend class Manager;
    friend class Clients;
};