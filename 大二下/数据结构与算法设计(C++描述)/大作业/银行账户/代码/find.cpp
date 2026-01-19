#include"Clients.h"
bool Clients::find(string id)
{
	BankAccount* pf;
	pf = head;
	while (pf->ID != id && pf->next != NULL){
		pf = pf->next;
	}
	if (pf->ID == id)
		return true;
	else 
		return false;
}