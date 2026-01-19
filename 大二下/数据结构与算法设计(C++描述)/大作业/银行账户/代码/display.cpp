#include"Manager.h"
#include <iomanip>
void Manager::display(BankAccount* p, int n) {
	cout << left << setw(6) << n;
	cout << left << setw(10) << p->ID;
	cout << left << setw(12) << p->name;
	cout << left << setw(16) << p->telephone;
	cout << left << setw(20) << p->email;
	cout << left << setw(20) << p->IDcard;
	cout << left << setw(20) << p->account_number;
	cout << left << setw(10) << p->balance << endl;
}