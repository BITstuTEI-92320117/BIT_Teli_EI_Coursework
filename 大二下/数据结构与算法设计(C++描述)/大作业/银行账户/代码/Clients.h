#pragma once
#include"BankAccount.h"
class Clients {
public:
    Clients();
	~Clients();
	int writein();
	BankAccount* login();
	void openaccounts();
	void transfer(BankAccount* q);
	void search(BankAccount* q);
	void modify(BankAccount* q);
	void save(BankAccount* q);
	void withdraw(BankAccount* q);
	void cancelaccount(BankAccount* q);
	bool find(string id);
	BankAccount* head;
	int number;
private:
	int length;
	int money;
	friend class Manager;
};
