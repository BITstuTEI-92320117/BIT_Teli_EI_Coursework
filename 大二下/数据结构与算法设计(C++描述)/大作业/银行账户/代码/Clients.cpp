#include"Clients.h"
Clients::Clients() {
	head = new BankAccount;
	length = 0;
	number = 0;
}
Clients::~Clients() {
	BankAccount* p = head->next;
	int i = 1;
	while (i++ <= length) {
		head->next = p->next;
		delete p;
		p = head->next;
	}
	delete p;
	delete head;
	length = 0;
}
