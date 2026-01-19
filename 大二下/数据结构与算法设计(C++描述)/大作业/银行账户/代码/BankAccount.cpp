#include"BankAccount.h"
BankAccount::BankAccount() {
    head = this;
    next = NULL;
}
BankAccount::BankAccount(string _ID, string _password, string _name, string _telephone, string _account_number, string _email, string _IDcard, double _balance)
{
    ID = _ID;
    password = _password;
    name = _name;
    telephone = _telephone;
    email = _email;
    IDcard = _IDcard;
    account_number = _account_number;
    balance = _balance;
}